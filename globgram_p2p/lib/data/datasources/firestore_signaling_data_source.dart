import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/room_selection/data/datasources/signaling_data_source.dart';
import '../../features/room_selection/data/models/signaling_models.dart';

class FirestoreSignalingDataSource implements SignalingDataSource {
  final FirebaseFirestore _firestore;
  
  FirestoreSignalingDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore {
    print('🚀 FirestoreSignalingDataSource initialized - USING NEW FILE!');
  }

  @override
  Future<String> createRoom(OfferData offer) async {
    // Simple implementation - create empty room
    final roomId = DateTime.now().millisecondsSinceEpoch.toString();
    await _firestore.collection('rooms').doc(roomId).set({
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'created',
      'offer': {
        'sdp': offer.sdp,
        'type': offer.type,
        'timestamp': offer.timestamp.toIso8601String(),
      }
    });
    return roomId;
  }

  @override
  Future<void> saveAnswer(String roomId, AnswerData answer) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'answer': {
        'sdp': answer.sdp,
        'type': answer.type,
        'timestamp': answer.timestamp.toIso8601String(),
      },
      'status': 'answered',
    });
  }

  @override
  Stream<AnswerData?> watchAnswer(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;
      
      final data = snapshot.data();
      if (data == null || !data.containsKey('answer')) return null;
      
      final answerData = data['answer'] as Map<String, dynamic>;
      return AnswerData(
        sdp: answerData['sdp'] ?? '',
        type: answerData['type'] ?? 'answer',
        timestamp: DateTime.parse(answerData['timestamp'] ?? DateTime.now().toIso8601String()),
      );
    });
  }

  @override
  Future<OfferData> fetchOffer(String roomId) async {
    final doc = await _firestore.collection('rooms').doc(roomId).get();
    
    if (!doc.exists) {
      throw Exception('Room not found');
    }
    
    final data = doc.data()!;
    final offerData = data['offer'] as Map<String, dynamic>;
    
    return OfferData(
      sdp: offerData['sdp'] ?? '',
      type: offerData['type'] ?? 'offer',
      timestamp: DateTime.parse(offerData['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  Future<void> addIceCandidate(String roomId, String role, IceCandidateModel candidate) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('iceCandidates')
        .add({
      'role': role,
      'candidate': candidate.candidate,
      'sdpMid': candidate.sdpMid,
      'sdpMLineIndex': candidate.sdpMLineIndex,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<IceCandidateModel>> watchIceCandidates(String roomId, String role) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('iceCandidates')
        .where('role', isEqualTo: role)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return IceCandidateModel(
          candidate: data['candidate'] ?? '',
          sdpMid: data['sdpMid'],
          sdpMLineIndex: data['sdpMLineIndex'],
          timestamp: DateTime.now(), // Add timestamp
        );
      }).toList();
    });
  }

  @override
  Future<bool> roomExists(String roomId) async {
    final doc = await _firestore.collection('rooms').doc(roomId).get();
    return doc.exists;
  }

  @override
  Future<void> cleanupRoom(String roomId) async {
    // Delete ice candidates subcollection first
    final candidatesQuery = await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('iceCandidates')
        .get();
    
    for (final doc in candidatesQuery.docs) {
      await doc.reference.delete();
    }
    
    // Delete the room document
    await _firestore.collection('rooms').doc(roomId).delete();
  }

  @override
  Future<void> clearSdpBodies(String roomId) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'offer.sdp': '',
      'answer.sdp': '',
      'sdp_cleared': true,
    });
  }

  @override
  Future<void> markRoomConnected(String roomId) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'status': 'connected',
      'connectedAt': FieldValue.serverTimestamp(),
    });
  }
}
