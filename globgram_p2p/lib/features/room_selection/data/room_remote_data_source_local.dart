import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';

/// Local storage implementation for WebRTC signaling (for testing without Firebase)
class RoomRemoteDataSourceLocal {
  static final Logger _logger = Logger();

  // In-memory storage for local testing
  static final Map<String, Map<String, dynamic>> _rooms = {};
  static final Map<String, StreamController<RTCIceCandidate>>
  _iceCandidateControllers = {};

  /// Set offer for a room
  Future<void> setOffer(String roomId, RTCSessionDescription offer) async {
    try {
      _rooms[roomId] = {
        ..._rooms[roomId] ?? {},
        'offer': {'type': offer.type, 'sdp': offer.sdp},
        'createdAt': DateTime.now().toIso8601String(),
      };
      _logger.i('Offer set for room: $roomId');
    } catch (e) {
      _logger.e('Failed to set offer: $e');
      rethrow;
    }
  }

  /// Set answer for a room
  Future<void> setAnswer(String roomId, RTCSessionDescription answer) async {
    try {
      _rooms[roomId] = {
        ..._rooms[roomId] ?? {},
        'answer': {'type': answer.type, 'sdp': answer.sdp},
        'answeredAt': DateTime.now().toIso8601String(),
      };
      _logger.i('Answer set for room: $roomId');
    } catch (e) {
      _logger.e('Failed to set answer: $e');
      rethrow;
    }
  }

  /// Get room data
  Future<Map<String, dynamic>?> getRoomData(String roomId) async {
    try {
      final roomData = _rooms[roomId];
      _logger.d(
        'Room data retrieved for $roomId: ${roomData != null ? 'found' : 'not found'}',
      );
      return roomData;
    } catch (e) {
      _logger.e('Failed to get room data: $e');
      rethrow;
    }
  }

  /// Add ICE candidate
  Future<void> addIceCandidate(
    String roomId,
    String type,
    RTCIceCandidate candidate,
  ) async {
    try {
      final key = '${roomId}_$type';

      // Initialize room if not exists
      _rooms[roomId] = _rooms[roomId] ?? {};

      // Initialize ice candidates list if not exists
      _rooms[roomId]!['iceCandidates'] = _rooms[roomId]!['iceCandidates'] ?? {};
      _rooms[roomId]!['iceCandidates'][type] =
          _rooms[roomId]!['iceCandidates'][type] ?? [];

      // Add candidate to the list
      final candidateData = {
        'candidate': candidate.candidate,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'sdpMid': candidate.sdpMid,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _rooms[roomId]!['iceCandidates'][type].add(candidateData);

      // Notify listeners
      if (_iceCandidateControllers.containsKey(key)) {
        _iceCandidateControllers[key]!.add(candidate);
      }

      _logger.d('ICE candidate added for $roomId ($type)');
    } catch (e) {
      _logger.e('Failed to add ICE candidate: $e');
      rethrow;
    }
  }

  /// Listen to ICE candidates
  Stream<RTCIceCandidate> listenIceCandidates(String roomId, String type) {
    final key = '${roomId}_$type';

    if (!_iceCandidateControllers.containsKey(key)) {
      _iceCandidateControllers[key] =
          StreamController<RTCIceCandidate>.broadcast();
    }

    // Send existing candidates
    Timer.run(() async {
      try {
        final roomData = _rooms[roomId];
        if (roomData != null && roomData['iceCandidates'] != null) {
          final candidatesList = roomData['iceCandidates'][type] as List?;
          if (candidatesList != null) {
            for (final candidateData in candidatesList) {
              final candidate = RTCIceCandidate(
                candidateData['candidate'],
                candidateData['sdpMid'],
                candidateData['sdpMLineIndex'],
              );
              _iceCandidateControllers[key]!.add(candidate);
            }
          }
        }
      } catch (e) {
        _logger.e('Error sending existing ICE candidates: $e');
      }
    });

    _logger.i('Listening to ICE candidates for $roomId ($type)');
    return _iceCandidateControllers[key]!.stream;
  }

  /// Create a new room
  Future<String> createRoom() async {
    // Generate shorter, more user-friendly room ID
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final shortId = timestamp.toString().substring(
      timestamp.toString().length - 6,
    );
    final roomId = 'R$shortId';

    _rooms[roomId] = {
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'waiting',
    };
    _logger.i('Room created: $roomId');
    return roomId;
  }

  /// Get available rooms
  Future<List<Map<String, dynamic>>> getAvailableRooms() async {
    final availableRooms = <Map<String, dynamic>>[];

    for (final entry in _rooms.entries) {
      final roomId = entry.key;
      final roomData = entry.value;
      if (roomData['offer'] != null && roomData['answer'] == null) {
        availableRooms.add({
          'id': roomId,
          'createdAt': roomData['createdAt'],
          'status': 'waiting',
        });
      }
    }

    _logger.i('Available rooms: ${availableRooms.length}');
    return availableRooms;
  }

  /// Clear all rooms (for testing)
  static void clearAllRooms() {
    _rooms.clear();
    for (var controller in _iceCandidateControllers.values) {
      controller.close();
    }
    _iceCandidateControllers.clear();
    Logger().i('All rooms cleared');
  }
}
