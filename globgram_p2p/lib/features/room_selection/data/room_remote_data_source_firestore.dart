import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';

class RoomRemoteDataSourceFirestore {
  static final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new room with WebRTC offer
  Future<String> createRoom() async {
    try {
      final roomId = _generateRoomId();
      
      await _firestore.collection('rooms').doc(roomId).set({
        'offer': null, // Will be set later when WebRTC offer is created
        'answer': null,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'waiting_for_answer',
      });

      _logger.i('Room created successfully: $roomId');
      return roomId;
    } catch (e) {
      _logger.e('Failed to create room: $e');
      rethrow;
    }
  }

  /// Join an existing room by reading offer and writing answer
  Future<void> joinRoom(String roomId) async {
    try {
      final roomDoc = await _firestore.collection('rooms').doc(roomId).get();
      
      if (!roomDoc.exists) {
        throw Exception('Room not found: $roomId');
      }

      final roomData = roomDoc.data()!;
      final offer = roomData['offer'];
      
      if (offer == null) {
        throw Exception('Room offer not available: $roomId');
      }

      // Update room status to indicate someone joined
      await _firestore.collection('rooms').doc(roomId).update({
        'status': 'answered',
        'joinedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Successfully joined room: $roomId');
    } catch (e) {
      _logger.e('Failed to join room $roomId: $e');
      rethrow;
    }
  }

  /// Add ICE candidate to Firestore
  Future<void> addIceCandidate(
    String roomId, 
    String type, // 'caller' or 'callee'
    RTCIceCandidate candidate,
  ) async {
    try {
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('candidates')
          .doc(type)
          .collection('list')
          .add({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _logger.d('ICE candidate added for $type in room $roomId');
    } catch (e) {
      _logger.e('Failed to add ICE candidate: $e');
      rethrow;
    }
  }

  /// Listen to ICE candidates stream
  Stream<RTCIceCandidate> listenIceCandidates(String roomId, String type) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('candidates')
        .doc(type)
        .collection('list')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      final candidates = <RTCIceCandidate>[];
      
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final candidate = RTCIceCandidate(
          data['candidate'] as String,
          data['sdpMid'] as String?,
          data['sdpMLineIndex'] as int?,
        );
        candidates.add(candidate);
      }
      
      return candidates;
    }).expand((candidates) => candidates);
  }

  /// Delete room and all sub-collections (caller only)
  Future<void> deleteRoom(String roomId) async {
    try {
      final batch = _firestore.batch();
      
      // Delete candidates subcollections
      final callerCandidates = await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('candidates')
          .doc('caller')
          .collection('list')
          .get();
      
      for (final doc in callerCandidates.docs) {
        batch.delete(doc.reference);
      }

      final calleeCandidates = await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('candidates')
          .doc('callee')
          .collection('list')
          .get();
      
      for (final doc in calleeCandidates.docs) {
        batch.delete(doc.reference);
      }

      // Delete candidates documents
      batch.delete(_firestore
          .collection('rooms')
          .doc(roomId)
          .collection('candidates')
          .doc('caller'));
      
      batch.delete(_firestore
          .collection('rooms')
          .doc(roomId)
          .collection('candidates')
          .doc('callee'));

      // Delete room document
      batch.delete(_firestore.collection('rooms').doc(roomId));
      
      await batch.commit();
      _logger.i('Room deleted successfully: $roomId');
    } catch (e) {
      _logger.e('Failed to delete room $roomId: $e');
      rethrow;
    }
  }

  /// Set WebRTC offer for a room
  Future<void> setOffer(String roomId, RTCSessionDescription offer) async {
    try {
      await _firestore.collection('rooms').doc(roomId).update({
        'offer': {
          'type': offer.type,
          'sdp': offer.sdp,
        },
      });
      _logger.i('Offer set for room: $roomId');
    } catch (e) {
      _logger.e('Failed to set offer for room $roomId: $e');
      rethrow;
    }
  }

  /// Set WebRTC answer for a room
  Future<void> setAnswer(String roomId, RTCSessionDescription answer) async {
    try {
      await _firestore.collection('rooms').doc(roomId).update({
        'answer': {
          'type': answer.type,
          'sdp': answer.sdp,
        },
        'status': 'connected',
      });
      _logger.i('Answer set for room: $roomId');
    } catch (e) {
      _logger.e('Failed to set answer for room $roomId: $e');
      rethrow;
    }
  }

  /// Get room data including offer/answer
  Future<Map<String, dynamic>?> getRoomData(String roomId) async {
    try {
      final doc = await _firestore.collection('rooms').doc(roomId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      _logger.e('Failed to get room data for $roomId: $e');
      rethrow;
    }
  }

  /// Listen to room changes
  Stream<Map<String, dynamic>?> listenToRoom(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null);
  }

  /// Generate random room ID
  String _generateRoomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      8,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
