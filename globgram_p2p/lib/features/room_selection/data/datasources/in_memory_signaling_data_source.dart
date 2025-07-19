import 'dart:async';
import '../models/signaling_models.dart';
import 'signaling_data_source.dart';

/// In-memory implementation of SignalingDataSource for testing and fallback
class InMemorySignalingDataSource implements SignalingDataSource {
  final Map<String, Map<String, dynamic>> _rooms = {};
  final Map<String, StreamController<OfferData?>> _offerControllers = {};
  final Map<String, StreamController<AnswerData?>> _answerControllers = {};
  final Map<String, StreamController<List<IceCandidateModel>>> _candidateControllers = {};

  @override
  Future<void> createRoom(String roomId) async {
    _rooms[roomId] = {
      'createdAt': DateTime.now(),
      'status': 'waiting',
      'callerConnected': true,
      'calleeConnected': false,
      'offers': <OfferData>[],
      'answers': <AnswerData>[],
      'callerCandidates': <IceCandidateModel>[],
      'calleeCandidates': <IceCandidateModel>[],
    };
  }

  @override
  Future<bool> joinRoom(String roomId) async {
    if (!_rooms.containsKey(roomId)) {
      throw Exception('Room $roomId does not exist');
    }

    final room = _rooms[roomId]!;
    if (room['calleeConnected'] == true) {
      return false; // Room is full
    }

    room['calleeConnected'] = true;
    room['status'] = 'connecting';
    return true;
  }

  @override
  Future<void> leaveRoom(String roomId) async {
    _rooms.remove(roomId);
    _offerControllers[roomId]?.close();
    _offerControllers.remove(roomId);
    _answerControllers[roomId]?.close();
    _answerControllers.remove(roomId);
    _candidateControllers.remove(roomId);
  }

  @override
  Future<bool> roomExists(String roomId) async {
    return _rooms.containsKey(roomId);
  }

  @override
  Future<void> sendOffer(String roomId, OfferData offer) async {
    if (!_rooms.containsKey(roomId)) {
      throw Exception('Room $roomId does not exist');
    }

    final offers = _rooms[roomId]!['offers'] as List<OfferData>;
    offers.add(offer);

    // Notify listeners
    _offerControllers[roomId]?.add(offer);
  }

  @override
  Stream<OfferData?> listenForOffer(String roomId) {
    if (!_offerControllers.containsKey(roomId)) {
      _offerControllers[roomId] = StreamController<OfferData?>.broadcast();
    }
    return _offerControllers[roomId]!.stream;
  }

  @override
  Future<void> sendAnswer(String roomId, AnswerData answer) async {
    if (!_rooms.containsKey(roomId)) {
      throw Exception('Room $roomId does not exist');
    }

    final answers = _rooms[roomId]!['answers'] as List<AnswerData>;
    answers.add(answer);

    // Notify listeners
    _answerControllers[roomId]?.add(answer);
  }

  @override
  Stream<AnswerData?> listenForAnswer(String roomId) {
    if (!_answerControllers.containsKey(roomId)) {
      _answerControllers[roomId] = StreamController<AnswerData?>.broadcast();
    }
    return _answerControllers[roomId]!.stream;
  }

  @override
  Future<void> addIceCandidate(String roomId, IceCandidateModel candidate, bool isFromCaller) async {
    if (!_rooms.containsKey(roomId)) {
      throw Exception('Room $roomId does not exist');
    }

    final candidatesKey = isFromCaller ? 'callerCandidates' : 'calleeCandidates';
    final candidates = _rooms[roomId]![candidatesKey] as List<IceCandidateModel>;
    candidates.add(candidate);

    // Notify listeners for the opposite role
    final listenerKey = '${roomId}_${!isFromCaller}';
    if (_candidateControllers.containsKey(listenerKey)) {
      _candidateControllers[listenerKey]!.add(List.from(candidates));
    }
  }

  @override
  Stream<List<IceCandidateModel>> listenForIceCandidates(String roomId, bool isForCaller) {
    final listenerKey = '${roomId}_$isForCaller';
    if (!_candidateControllers.containsKey(listenerKey)) {
      _candidateControllers[listenerKey] = StreamController<List<IceCandidateModel>>.broadcast();
    }
    return _candidateControllers[listenerKey]!.stream;
  }

  @override
  Future<void> clearRoom(String roomId) async {
    await leaveRoom(roomId);
  }

  /// Dispose all resources
  void dispose() {
    for (final controller in _offerControllers.values) {
      controller.close();
    }
    for (final controller in _answerControllers.values) {
      controller.close();
    }
    for (final controller in _candidateControllers.values) {
      controller.close();
    }
    
    _offerControllers.clear();
    _answerControllers.clear();
    _candidateControllers.clear();
    _rooms.clear();
  }
}
