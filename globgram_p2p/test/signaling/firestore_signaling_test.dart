import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/firestore_signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';

// Mock classes
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockWriteBatch extends Mock implements WriteBatch {}
class MockFieldValue extends Mock implements FieldValue {}

void main() {
  group('FirestoreSignalingDataSource', () {
    late FirestoreSignalingDataSource dataSource;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockRoomsCollection;
    late MockDocumentReference mockRoomDocument;
    late MockDocumentReference mockCandidateDocument;
    late MockCollectionReference mockCandidatesCollection;
    late MockWriteBatch mockBatch;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockRoomsCollection = MockCollectionReference();
      mockRoomDocument = MockDocumentReference();
      mockCandidateDocument = MockDocumentReference();
      mockCandidatesCollection = MockCollectionReference();
      mockBatch = MockWriteBatch();

      // Setup default mocks
      when(() => mockFirestore.collection('rooms')).thenReturn(mockRoomsCollection);
      when(() => mockRoomsCollection.doc(any())).thenReturn(mockRoomDocument);
      when(() => mockRoomDocument.collection('candidates')).thenReturn(mockCandidatesCollection);
      when(() => mockCandidatesCollection.doc()).thenReturn(mockCandidateDocument);
      when(() => mockFirestore.batch()).thenReturn(mockBatch);

      dataSource = FirestoreSignalingDataSource(firestore: mockFirestore);
    });

    group('createRoom', () {
      test('should create room with offer and return room ID', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp-offer',
          type: 'offer',
          timestamp: DateTime.parse('2024-01-01T12:00:00Z'),
        );

        when(() => mockRoomDocument.set(any())).thenAnswer((_) async {});

        // Act
        final roomId = await dataSource.createRoom(offer);

        // Assert
        expect(roomId, isNotEmpty);
        expect(roomId.length, equals(8));
        
        // Verify that Firestore set was called with correct data
        final captured = verify(() => mockRoomDocument.set(captureAny())).captured.first;
        expect(captured['offer']['sdp'], equals('test-sdp-offer'));
        expect(captured['offer']['type'], equals('offer'));
        expect(captured['offer']['timestamp'], equals('2024-01-01T12:00:00.000Z'));
        expect(captured['status'], equals('waiting_for_answer'));
      });

      test('should handle Firestore errors', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );

        when(() => mockRoomDocument.set(any())).thenThrow(
          FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
        );

        // Act & Assert
        expect(
          () => dataSource.createRoom(offer),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('saveAnswer', () {
      test('should save answer to existing room', () async {
        // Arrange
        const roomId = 'TEST1234';
        final answer = AnswerData(
          sdp: 'test-sdp-answer',
          type: 'answer',
          timestamp: DateTime.parse('2024-01-01T12:30:00Z'),
        );

        when(() => mockRoomDocument.update(any())).thenAnswer((_) async {});

        // Act
        await dataSource.saveAnswer(roomId, answer);

        // Assert
        final captured = verify(() => mockRoomDocument.update(captureAny())).captured.first;
        expect(captured['answer']['sdp'], equals('test-sdp-answer'));
        expect(captured['answer']['type'], equals('answer'));
        expect(captured['answer']['timestamp'], equals('2024-01-01T12:30:00.000Z'));
        expect(captured['status'], equals('connected'));
      });

      test('should handle update errors', () async {
        // Arrange
        const roomId = 'TEST1234';
        final answer = AnswerData(
          sdp: 'test-sdp-answer',
          type: 'answer',
          timestamp: DateTime.now(),
        );

        when(() => mockRoomDocument.update(any())).thenThrow(
          FirebaseException(plugin: 'cloud_firestore', code: 'not-found'),
        );

        // Act & Assert
        expect(
          () => dataSource.saveAnswer(roomId, answer),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('watchAnswer', () {
      test('should emit answer when document updates', () async {
        // Arrange
        const roomId = 'TEST1234';
        final mockSnapshot = MockDocumentSnapshot();
        final streamController = StreamController<DocumentSnapshot<Map<String, dynamic>>>();

        when(() => mockRoomDocument.snapshots()).thenAnswer((_) => streamController.stream);
        when(() => mockSnapshot.exists).thenReturn(true);
        when(() => mockSnapshot.data()).thenReturn({
          'answer': {
            'sdp': 'answer-sdp',
            'type': 'answer',
            'timestamp': '2024-01-01T12:30:00.000Z',
          },
        });

        // Act
        final stream = dataSource.watchAnswer(roomId);
        late AnswerData? result;
        final subscription = stream.listen((answer) {
          result = answer;
        });

        streamController.add(mockSnapshot);
        await Future.delayed(Duration.zero); // Let stream process

        // Assert
        expect(result, isNotNull);
        expect(result!.sdp, equals('answer-sdp'));
        expect(result!.type, equals('answer'));
        expect(result!.timestamp, equals(DateTime.parse('2024-01-01T12:30:00.000Z')));

        // Cleanup
        await subscription.cancel();
        await streamController.close();
      });

      test('should emit null when no answer exists', () async {
        // Arrange
        const roomId = 'TEST1234';
        final mockSnapshot = MockDocumentSnapshot();
        final streamController = StreamController<DocumentSnapshot<Map<String, dynamic>>>();

        when(() => mockRoomDocument.snapshots()).thenAnswer((_) => streamController.stream);
        when(() => mockSnapshot.exists).thenReturn(true);
        when(() => mockSnapshot.data()).thenReturn({'offer': {}});

        // Act
        final stream = dataSource.watchAnswer(roomId);
        late AnswerData? result;
        final subscription = stream.listen((answer) {
          result = answer;
        });

        streamController.add(mockSnapshot);
        await Future.delayed(Duration.zero);

        // Assert
        expect(result, isNull);

        // Cleanup
        await subscription.cancel();
        await streamController.close();
      });

      test('should emit null when document does not exist', () async {
        // Arrange
        const roomId = 'TEST1234';
        final mockSnapshot = MockDocumentSnapshot();
        final streamController = StreamController<DocumentSnapshot<Map<String, dynamic>>>();

        when(() => mockRoomDocument.snapshots()).thenAnswer((_) => streamController.stream);
        when(() => mockSnapshot.exists).thenReturn(false);

        // Act
        final stream = dataSource.watchAnswer(roomId);
        late AnswerData? result;
        final subscription = stream.listen((answer) {
          result = answer;
        });

        streamController.add(mockSnapshot);
        await Future.delayed(Duration.zero);

        // Assert
        expect(result, isNull);

        // Cleanup
        await subscription.cancel();
        await streamController.close();
      });
    });

    group('fetchOffer', () {
      test('should fetch offer from existing room', () async {
        // Arrange
        const roomId = 'TEST1234';
        final mockSnapshot = MockDocumentSnapshot();

        when(() => mockRoomDocument.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(true);
        when(() => mockSnapshot.data()).thenReturn({
          'offer': {
            'sdp': 'offer-sdp-test',
            'type': 'offer',
            'timestamp': '2024-01-01T12:00:00.000Z',
          },
        });

        // Act
        final offer = await dataSource.fetchOffer(roomId);

        // Assert
        expect(offer.sdp, equals('offer-sdp-test'));
        expect(offer.type, equals('offer'));
        expect(offer.timestamp, equals(DateTime.parse('2024-01-01T12:00:00.000Z')));
      });

      test('should throw exception when room does not exist', () async {
        // Arrange
        const roomId = 'INVALID123';
        final mockSnapshot = MockDocumentSnapshot();

        when(() => mockRoomDocument.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(false);

        // Act & Assert
        expect(
          () => dataSource.fetchOffer(roomId),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Room INVALID123 does not exist'),
          )),
        );
      });

      test('should throw exception when offer is cleared', () async {
        // Arrange
        const roomId = 'TEST1234';
        final mockSnapshot = MockDocumentSnapshot();

        when(() => mockRoomDocument.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(true);
        when(() => mockSnapshot.data()).thenReturn({
          'offer': {
            'cleared': true,
          },
        });

        // Act & Assert
        expect(
          () => dataSource.fetchOffer(roomId),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Offer SDP has been cleared for security'),
          )),
        );
      });

      test('should throw exception when no offer exists', () async {
        // Arrange
        const roomId = 'TEST1234';
        final mockSnapshot = MockDocumentSnapshot();

        when(() => mockRoomDocument.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(true);
        when(() => mockSnapshot.data()).thenReturn({
          'status': 'created',
        });

        // Act & Assert
        expect(
          () => dataSource.fetchOffer(roomId),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('No offer found for room TEST1234'),
          )),
        );
      });
    });

    group('addIceCandidate', () {
      test('should add ICE candidate to correct sub-collection', () async {
        // Arrange
        const roomId = 'TEST1234';
        const role = 'caller';
        final candidate = IceCandidateModel(
          candidate: 'candidate:1 1 UDP 2113667326 192.168.1.100 54400 typ host',
          sdpMid: '0',
          sdpMLineIndex: 0,
          timestamp: DateTime.parse('2024-01-01T12:15:00Z'),
        );

        when(() => mockCandidateDocument.set(any())).thenAnswer((_) async {});

        // Act
        await dataSource.addIceCandidate(roomId, role, candidate);

        // Assert
        verify(() => mockRoomDocument.collection('candidates')).called(1);
        verify(() => mockCandidatesCollection.doc()).called(1);
        
        final captured = verify(() => mockCandidateDocument.set(captureAny())).captured.first;
        expect(captured['candidate'], equals('candidate:1 1 UDP 2113667326 192.168.1.100 54400 typ host'));
        expect(captured['sdpMid'], equals('0'));
        expect(captured['sdpMLineIndex'], equals(0));
        expect(captured['timestamp'], equals('2024-01-01T12:15:00.000Z'));
        expect(captured['role'], equals('caller'));
      });

      test('should handle Firestore errors when adding candidate', () async {
        // Arrange
        const roomId = 'TEST1234';
        const role = 'caller';
        final candidate = IceCandidateModel(
          candidate: 'test-candidate',
          sdpMid: '0',
          sdpMLineIndex: 0,
          timestamp: DateTime.now(),
        );

        when(() => mockCandidateDocument.set(any())).thenThrow(
          FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
        );

        // Act & Assert
        expect(
          () => dataSource.addIceCandidate(roomId, role, candidate),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('watchIceCandidates', () {
      test('should watch ICE candidates for specific role', () async {
        // Arrange
        const roomId = 'TEST1234';
        const role = 'callee';
        
        final mockRoomSnapshot = MockDocumentSnapshot();
        final mockQuerySnapshot = MockQuerySnapshot();
        final mockQueryDoc = MockQueryDocumentSnapshot();
        
        final roomStreamController = StreamController<DocumentSnapshot<Map<String, dynamic>>>();

        when(() => mockRoomDocument.snapshots()).thenAnswer((_) => roomStreamController.stream);
        when(() => mockRoomSnapshot.exists).thenReturn(true);
        when(() => mockRoomSnapshot.data()).thenReturn({'connected': false});
        
        when(() => mockCandidatesCollection.where('role', isEqualTo: role))
            .thenReturn(mockCandidatesCollection);
        when(() => mockCandidatesCollection.orderBy('createdAt', descending: false))
            .thenReturn(mockCandidatesCollection);
        when(() => mockCandidatesCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
        
        when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDoc]);
        when(() => mockQueryDoc.data()).thenReturn({
          'candidate': 'test-candidate-data',
          'sdpMid': '1',
          'sdpMLineIndex': 1,
          'timestamp': '2024-01-01T12:20:00.000Z',
          'role': 'callee',
        });

        // Act
        final stream = dataSource.watchIceCandidates(roomId, role);
        late List<IceCandidateModel> result;
        final subscription = stream.listen((candidates) {
          result = candidates;
        });

        roomStreamController.add(mockRoomSnapshot);
        await Future.delayed(Duration.zero);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.candidate, equals('test-candidate-data'));
        expect(result.first.sdpMid, equals('1'));
        expect(result.first.sdpMLineIndex, equals(1));
        expect(result.first.timestamp, equals(DateTime.parse('2024-01-01T12:20:00.000Z')));

        // Cleanup
        await subscription.cancel();
        await roomStreamController.close();
      });

      test('should return empty list when room is connected', () async {
        // Arrange
        const roomId = 'TEST1234';
        const role = 'caller';
        
        final mockRoomSnapshot = MockDocumentSnapshot();
        final roomStreamController = StreamController<DocumentSnapshot<Map<String, dynamic>>>();

        when(() => mockRoomDocument.snapshots()).thenAnswer((_) => roomStreamController.stream);
        when(() => mockRoomSnapshot.exists).thenReturn(true);
        when(() => mockRoomSnapshot.data()).thenReturn({'connected': true});

        // Act
        final stream = dataSource.watchIceCandidates(roomId, role);
        late List<IceCandidateModel> result;
        final subscription = stream.listen((candidates) {
          result = candidates;
        });

        roomStreamController.add(mockRoomSnapshot);
        await Future.delayed(Duration.zero);

        // Assert
        expect(result, isEmpty);

        // Cleanup
        await subscription.cancel();
        await roomStreamController.close();
      });
    });

    group('roomExists', () {
      test('should return true when room exists', () async {
        // Arrange
        const roomId = 'TEST1234';
        final mockSnapshot = MockDocumentSnapshot();

        when(() => mockRoomDocument.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(true);

        // Act
        final exists = await dataSource.roomExists(roomId);

        // Assert
        expect(exists, isTrue);
      });

      test('should return false when room does not exist', () async {
        // Arrange
        const roomId = 'INVALID123';
        final mockSnapshot = MockDocumentSnapshot();

        when(() => mockRoomDocument.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(false);

        // Act
        final exists = await dataSource.roomExists(roomId);

        // Assert
        expect(exists, isFalse);
      });
    });

    group('clearSdpBodies', () {
      test('should clear SDP bodies for security', () async {
        // Arrange
        const roomId = 'TEST1234';
        when(() => mockRoomDocument.update(any())).thenAnswer((_) async {});

        // Act
        await dataSource.clearSdpBodies(roomId);

        // Assert
        final captured = verify(() => mockRoomDocument.update(captureAny())).captured.first;
        expect(captured['offer']['cleared'], isTrue);
        expect(captured['answer']['cleared'], isTrue);
        expect(captured['sdp_cleared'], isTrue);
      });
    });

    group('markRoomConnected', () {
      test('should mark room as connected', () async {
        // Arrange
        const roomId = 'TEST1234';
        when(() => mockRoomDocument.update(any())).thenAnswer((_) async {});

        // Act
        await dataSource.markRoomConnected(roomId);

        // Assert
        final captured = verify(() => mockRoomDocument.update(captureAny())).captured.first;
        expect(captured['connected'], isTrue);
        expect(captured['status'], equals('ice_connected'));
      });
    });

    group('cleanupRoom', () {
      test('should cleanup room and all candidates', () async {
        // Arrange
        const roomId = 'TEST1234';
        final mockQuerySnapshot = MockQuerySnapshot();
        final mockQueryDoc = MockQueryDocumentSnapshot();

        when(() => mockCandidatesCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDoc]);
        when(() => mockQueryDoc.reference).thenReturn(mockCandidateDocument);
        when(() => mockBatch.delete(any())).thenReturn(mockBatch);
        when(() => mockBatch.commit()).thenAnswer((_) async {});

        // Act
        await dataSource.cleanupRoom(roomId);

        // Assert
        verify(() => mockRoomDocument.collection('candidates')).called(1);
        verify(() => mockCandidatesCollection.get()).called(1);
        verify(() => mockBatch.delete(mockCandidateDocument)).called(1);
        verify(() => mockBatch.delete(mockRoomDocument)).called(1);
        verify(() => mockBatch.commit()).called(1);
      });

      test('should handle cleanup errors gracefully', () async {
        // Arrange
        const roomId = 'TEST1234';
        when(() => mockCandidatesCollection.get()).thenThrow(
          FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
        );

        // Act & Assert (should not throw)
        await dataSource.cleanupRoom(roomId);
        
        // Verify it was attempted
        verify(() => mockRoomDocument.collection('candidates')).called(1);
      });
    });
  });
}
