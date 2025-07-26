import 'package:cloud_firestore/cloud_firestore.dart';
import 'signaling_data_source.dart';
import '../models/signaling_models.dart';

class FirestoreSignalingDataSource implements SignalingDataSource {
  final FirebaseFirestore firestore;
  
  FirestoreSignalingDataSource({required this.firestore});

  @override
  Future<String> createRoom(OfferData offer) async {
    // Create room with offer data
    final roomId = DateTime.now().millisecondsSinceEpoch.toString();
    print('🏗️ Creating room with ID: $roomId');
    
    try {
      await firestore.collection('rooms').doc(roomId).set({
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'created',
        'offer': {
          'sdp': offer.sdp,
          'type': offer.type,
          'timestamp': offer.timestamp.toIso8601String(),
        }
      });
      print('✅ Room $roomId created successfully in Firestore');
      print('🔄 About to return roomId: $roomId');
      return roomId;
    } catch (e) {
      print('❌ Error creating room $roomId: $e');
      throw e;
    }
  }

  // Create room with specific ID
  Future<void> createRoomWithId(String roomId, OfferData offer) async {
    print('🏗️ Creating room with specific ID: $roomId');
    
    try {
      await firestore.collection('rooms').doc(roomId).set({
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'created',
        'offer': {
          'sdp': offer.sdp,
          'type': offer.type,
          'timestamp': offer.timestamp.toIso8601String(),
        }
      });
      print('✅ Room $roomId created successfully in Firestore');
    } catch (e) {
      print('❌ Error creating room $roomId: $e');
      throw e;
    }
  }

  @override
  Future<void> saveAnswer(String roomId, AnswerData answer) async {
    print('💾 Saving real answer for room: $roomId');
    try {
      await firestore.collection('rooms').doc(roomId).update({
        'answer': {
          'sdp': answer.sdp,
          'type': answer.type,
          'timestamp': answer.timestamp.toIso8601String(),
        }
      });
      print('✅ Real answer saved successfully');
    } catch (error) {
      print('❌ Error saving answer: $error');
      rethrow;
    }
  }

  @override
  Stream<AnswerData?> watchAnswer(String roomId) {
    print('🔍 Starting to watch answer for room: $roomId');
    return firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) {
      print('📄 Snapshot received for room $roomId: exists=${snapshot.exists}');
      
      if (!snapshot.exists) {
        print('❌ Room $roomId does not exist');
        return null;
      }
      
      final data = snapshot.data();
      print('📊 Room data: $data');
      
      if (data == null || !data.containsKey('answer')) {
        print('⏳ No answer field found, continuing to wait...');
        return null;
      }
      
      print('✅ Answer field found: ${data['answer']}');
      
      // If answer is just a string "saved", return null to continue waiting
      if (data['answer'] == 'saved') {
        print('📝 Answer is just "saved", continuing to wait for real answer...');
        return null;
      }
      
      // If answer is a proper object, parse it
      if (data['answer'] is Map<String, dynamic>) {
        print('🎯 Parsing answer object...');
        final answerData = data['answer'] as Map<String, dynamic>;
        return AnswerData(
          sdp: answerData['sdp'] ?? '',
          type: answerData['type'] ?? 'answer',
          timestamp: DateTime.parse(answerData['timestamp'] ?? DateTime.now().toIso8601String()),
        );
      }
      
      print('🤷 Unknown answer format, returning null');
      return null;
    });
  }

  @override
  Future<OfferData> fetchOffer(String roomId) async {
    final doc = await firestore.collection('rooms').doc(roomId).get();
    
    if (!doc.exists) {
      throw Exception('Room not found: $roomId');
    }
    
    final data = doc.data()!;
    if (!data.containsKey('offer')) {
      throw Exception('No offer found in room: $roomId');
    }
    
    final offerData = data['offer'] as Map<String, dynamic>;
    return OfferData(
      sdp: offerData['sdp'] ?? '',
      type: offerData['type'] ?? 'offer',
      timestamp: DateTime.parse(offerData['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  Future<void> addIceCandidate(String roomId, String role, IceCandidateModel candidate) async {
    print('🧊 Adding ICE candidate for $role in room: $roomId');
    try {
      await firestore
          .collection('rooms')
          .doc(roomId)
          .collection('iceCandidates')
          .doc('${role}_${DateTime.now().millisecondsSinceEpoch}')
          .set({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'role': role,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ ICE candidate added successfully');
    } catch (error) {
      print('❌ Error adding ICE candidate: $error');
      rethrow;
    }
  }

  @override
  Stream<List<IceCandidateModel>> watchIceCandidates(String roomId, String role) {
    print('👀 Watching ICE candidates for $role in room: $roomId');
    return firestore
        .collection('rooms')
        .doc(roomId)
        .collection('iceCandidates')
        .snapshots()
        .map((snapshot) {
      // Filter by role in code instead of query to avoid index requirement
      final candidates = snapshot.docs
          .where((doc) => doc.data()['role'] == role)
          .map((doc) {
        final data = doc.data();
        return IceCandidateModel(
          candidate: data['candidate'] ?? '',
          sdpMid: data['sdpMid'],
          sdpMLineIndex: data['sdpMLineIndex'],
          timestamp: DateTime.now(),
        );
      }).toList();
      print('🔄 Received ${candidates.length} ICE candidates for $role');
      return candidates;
    }).handleError((error) {
      print('❌ Error watching ICE candidates: $error');
      return <IceCandidateModel>[];
    });
  }

  @override
  Future<bool> roomExists(String roomId) async {
    final doc = await firestore.collection('rooms').doc(roomId).get();
    return doc.exists;
  }

  @override
  Future<void> cleanupRoom(String roomId) async {
    await firestore.collection('rooms').doc(roomId).delete();
  }

  @override
  Future<void> clearSdpBodies(String roomId) async {
    await firestore.collection('rooms').doc(roomId).update({
      'sdp_cleared': true,
    });
  }

  @override
  Future<void> markRoomConnected(String roomId) async {
    await firestore.collection('rooms').doc(roomId).update({
      'status': 'connected',
    });
  }
}
