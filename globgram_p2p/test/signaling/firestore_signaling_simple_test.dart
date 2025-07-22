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

void main() {
  group('FirestoreSignalingDataSource Tests', () {
    late FirestoreSignalingDataSource dataSource;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockRoomsCollection;
    late MockDocumentReference mockRoomDocument;
    late MockDocumentReference mockCandidateDocument;
    late MockCollectionReference mockCandidatesCollection;
    late MockWriteBatch mockBatch;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockRoomsCollection = MockCollectionReference<Map<String, dynamic>>();
      mockRoomDocument = MockDocumentReference<Map<String, dynamic>>();
      mockCandidateDocument = MockDocumentReference<Map<String, dynamic>>();
      mockCandidatesCollection = MockCollectionReference<Map<String, dynamic>>();
      mockBatch = MockWriteBatch();

      // Setup default mocks
      when(() => mockFirestore.collection('rooms')).thenReturn(mockRoomsCollection);
      when(() => mockRoomsCollection.doc(any())).thenReturn(mockRoomDocument);
      when(() => mockRoomDocument.collection('candidates')).thenReturn(mockCandidatesCollection);
      when(() => mockCandidatesCollection.doc()).thenReturn(mockCandidateDocument);
      when(() => mockFirestore.batch()).thenReturn(mockBatch);

      dataSource = FirestoreSignalingDataSource(firestore: mockFirestore);
    });

    test('should create room with offer successfully', () async {
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

    test('should watch answer when document updates', () async {
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
  });
}
