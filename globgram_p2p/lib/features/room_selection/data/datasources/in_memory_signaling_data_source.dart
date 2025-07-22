import 'dart:async';
import 'dart:math';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';

/// Internal memory model for room data
class RoomMemoryModel {
  OfferData? offer;
  AnswerData? answer;
  final List<IceCandidateModel> callerCandidates = [];
  final List<IceCandidateModel> calleeCandidates = [];
  final DateTime createdAt = DateTime.now();
  bool connected = false;
  bool sdpCleared = false;

  RoomMemoryModel({this.offer, this.answer});
}

/// In-memory implementation of SignalingDataSource for testing and fallback
class InMemorySignalingDataSource implements SignalingDataSource {
  final Map<String, RoomMemoryModel> _rooms = {};
  final Map<String, StreamController<AnswerData?>> _answerControllers = {};
  final Map<String, StreamController<List<IceCandidateModel>>> _candidateControllers = {};
  final Random _random = Random();

  /// Generate a simple room ID
  String _generateRoomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      8,
      (index) => chars[_random.nextInt(chars.length)],
    ).join();
  }

  @override
  Future<String> createRoom(OfferData offer) async {
    final roomId = _generateRoomId();
    _rooms[roomId] = RoomMemoryModel(offer: offer);
    return roomId;
  }

  @override
  Future<void> saveAnswer(String roomId, AnswerData answer) async {
    final room = _rooms[roomId];
    if (room == null) {
      throw Exception('Room $roomId does not exist');
    }
    
    room.answer = answer;
    
    // Notify answer watchers
    _answerControllers[roomId]?.add(answer);
  }

  @override
  Stream<AnswerData?> watchAnswer(String roomId) {
    if (!_answerControllers.containsKey(roomId)) {
      _answerControllers[roomId] = StreamController<AnswerData?>.broadcast();
    }
    
    // Emit current answer if exists
    final room = _rooms[roomId];
    if (room?.answer != null) {
      Future.microtask(() => _answerControllers[roomId]?.add(room!.answer));
    }
    
    return _answerControllers[roomId]!.stream;
  }

  @override
  Future<OfferData> fetchOffer(String roomId) async {
    final room = _rooms[roomId];
    if (room == null) {
      throw Exception('Room $roomId does not exist');
    }
    if (room.offer == null) {
      throw Exception('No offer found for room $roomId');
    }
    return room.offer!;
  }

  @override
  Future<void> addIceCandidate(
    String roomId,
    String role,
    IceCandidateModel candidate,
  ) async {
    final room = _rooms[roomId];
    if (room == null) {
      throw Exception('Room $roomId does not exist');
    }

    // Don't add candidates if room is connected
    if (room.connected) {
      return;
    }

    final candidates = role == 'caller' 
        ? room.callerCandidates 
        : room.calleeCandidates;
    candidates.add(candidate);

    // Notify watchers for this role
    final controllerKey = '${roomId}_$role';
    _candidateControllers[controllerKey]?.add(List.from(candidates));
  }

  @override
  Stream<List<IceCandidateModel>> watchIceCandidates(
    String roomId,
    String role,
  ) {
    final controllerKey = '${roomId}_$role';
    if (!_candidateControllers.containsKey(controllerKey)) {
      _candidateControllers[controllerKey] = 
          StreamController<List<IceCandidateModel>>.broadcast();
    }

    // Emit current candidates if any exist
    final room = _rooms[roomId];
    if (room != null) {
      final candidates = role == 'caller' 
          ? room.callerCandidates 
          : room.calleeCandidates;
      
      // If room is connected, don't emit candidates
      if (room.connected) {
        Future.microtask(() => 
            _candidateControllers[controllerKey]?.add([]));
      } else if (candidates.isNotEmpty) {
        Future.microtask(() => 
            _candidateControllers[controllerKey]?.add(List.from(candidates)));
      }
    }

    return _candidateControllers[controllerKey]!.stream;
  }

  @override
  Future<bool> roomExists(String roomId) async {
    return _rooms.containsKey(roomId);
  }

  @override
  Future<void> clearSdpBodies(String roomId) async {
    final room = _rooms[roomId];
    if (room != null) {
      room.sdpCleared = true;
      room.offer = null;
      room.answer = null;
    }
  }

  @override
  Future<void> markRoomConnected(String roomId) async {
    final room = _rooms[roomId];
    if (room != null) {
      room.connected = true;
    }
  }

  @override
  Future<void> cleanupRoom(String roomId) async {
    await clearRoom(roomId);
  }

  /// Clear a specific room and complete its streams
  Future<void> clearRoom(String roomId) async {
    _rooms.remove(roomId);
    
    // Complete and remove answer controller
    _answerControllers[roomId]?.close();
    _answerControllers.remove(roomId);
    
    // Complete and remove candidate controllers
    _candidateControllers['${roomId}_caller']?.close();
    _candidateControllers['${roomId}_callee']?.close();
    _candidateControllers.remove('${roomId}_caller');
    _candidateControllers.remove('${roomId}_callee');
  }

  /// Dispose all resources
  void dispose() {
    for (final controller in _answerControllers.values) {
      controller.close();
    }
    for (final controller in _candidateControllers.values) {
      controller.close();
    }

    _answerControllers.clear();
    _candidateControllers.clear();
    _rooms.clear();
  }
}
