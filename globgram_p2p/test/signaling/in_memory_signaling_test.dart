import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/in_memory_signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';

void main() {
  group('InMemorySignalingDataSource', () {
    late InMemorySignalingDataSource dataSource;

    setUp(() {
      dataSource = InMemorySignalingDataSource();
    });

    tearDown(() {
      dataSource.dispose();
    });

    group('createRoom + fetchOffer', () {
      test('should create room with offer and return room ID', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );

        // Act
        final roomId = await dataSource.createRoom(offer);

        // Assert
        expect(roomId, isNotEmpty);
        expect(roomId.length, equals(8));
        expect(await dataSource.roomExists(roomId), isTrue);
      });

      test('should fetch offer for existing room', () async {
        // Arrange
        final originalOffer = OfferData(
          sdp: 'test-sdp-123',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(originalOffer);

        // Act
        final fetchedOffer = await dataSource.fetchOffer(roomId);

        // Assert
        expect(fetchedOffer.sdp, equals(originalOffer.sdp));
        expect(fetchedOffer.type, equals(originalOffer.type));
        expect(fetchedOffer.timestamp, equals(originalOffer.timestamp));
      });

      test('should throw exception when fetching offer from non-existent room', () async {
        // Act & Assert
        expect(
          () => dataSource.fetchOffer('non-existent-room'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('saveAnswer + watchAnswer', () {
      test('should save answer and emit through stream', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(offer);
        
        final answer = AnswerData(
          sdp: 'test-answer-sdp',
          type: 'answer',
          timestamp: DateTime.now(),
        );

        final answerStream = dataSource.watchAnswer(roomId);
        final answerCompleter = Completer<AnswerData?>();
        
        answerStream.listen((data) {
          if (!answerCompleter.isCompleted) {
            answerCompleter.complete(data);
          }
        });

        // Act
        await dataSource.saveAnswer(roomId, answer);
        final receivedAnswer = await answerCompleter.future;

        // Assert
        expect(receivedAnswer, isNotNull);
        expect(receivedAnswer!.sdp, equals(answer.sdp));
        expect(receivedAnswer.type, equals(answer.type));
      });

      test('should emit null initially when no answer exists', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(offer);

        // Act
        final answerStream = dataSource.watchAnswer(roomId);
        
        // Assert - should not emit anything initially since no answer exists
        bool hasEmitted = false;
        final subscription = answerStream.listen((data) {
          hasEmitted = true;
        });

        await Future.delayed(const Duration(milliseconds: 100));
        expect(hasEmitted, isFalse);
        
        await subscription.cancel();
      });

      test('should throw exception when saving answer to non-existent room', () async {
        // Arrange
        final answer = AnswerData(
          sdp: 'test-answer-sdp',
          type: 'answer',
          timestamp: DateTime.now(),
        );

        // Act & Assert
        expect(
          () => dataSource.saveAnswer('non-existent-room', answer),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('addIceCandidate + watchIceCandidates', () {
      test('should add and watch ICE candidates for caller role', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(offer);
        
        final candidate = IceCandidateModel(
          candidate: 'candidate:1 1 UDP 2130706431 192.168.1.100 54400 typ host',
          sdpMid: 'data',
          sdpMLineIndex: 0,
          timestamp: DateTime.now(),
        );

        final candidatesStream = dataSource.watchIceCandidates(roomId, 'caller');
        final candidatesCompleter = Completer<List<IceCandidateModel>>();
        
        candidatesStream.listen((candidates) {
          if (!candidatesCompleter.isCompleted && candidates.isNotEmpty) {
            candidatesCompleter.complete(candidates);
          }
        });

        // Act
        await dataSource.addIceCandidate(roomId, 'caller', candidate);
        final receivedCandidates = await candidatesCompleter.future;

        // Assert
        expect(receivedCandidates, hasLength(1));
        expect(receivedCandidates.first.candidate, equals(candidate.candidate));
        expect(receivedCandidates.first.sdpMid, equals(candidate.sdpMid));
        expect(receivedCandidates.first.sdpMLineIndex, equals(candidate.sdpMLineIndex));
      });

      test('should add and watch ICE candidates for callee role', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(offer);
        
        final candidate = IceCandidateModel(
          candidate: 'candidate:2 1 UDP 2130706431 192.168.1.101 54401 typ host',
          sdpMid: 'data',
          sdpMLineIndex: 0,
          timestamp: DateTime.now(),
        );

        final candidatesStream = dataSource.watchIceCandidates(roomId, 'callee');
        final candidatesCompleter = Completer<List<IceCandidateModel>>();
        
        candidatesStream.listen((candidates) {
          if (!candidatesCompleter.isCompleted && candidates.isNotEmpty) {
            candidatesCompleter.complete(candidates);
          }
        });

        // Act
        await dataSource.addIceCandidate(roomId, 'callee', candidate);
        final receivedCandidates = await candidatesCompleter.future;

        // Assert
        expect(receivedCandidates, hasLength(1));
        expect(receivedCandidates.first.candidate, equals(candidate.candidate));
      });

      test('should separate candidates by role', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(offer);
        
        final callerCandidate = IceCandidateModel(
          candidate: 'caller-candidate',
          sdpMid: 'data',
          sdpMLineIndex: 0,
          timestamp: DateTime.now(),
        );
        
        final calleeCandidate = IceCandidateModel(
          candidate: 'callee-candidate',
          sdpMid: 'data',
          sdpMLineIndex: 0,
          timestamp: DateTime.now(),
        );

        // Set up streams
        final callerStream = dataSource.watchIceCandidates(roomId, 'caller');
        final calleeStream = dataSource.watchIceCandidates(roomId, 'callee');
        
        final callerCandidates = <List<IceCandidateModel>>[];
        final calleeCandidates = <List<IceCandidateModel>>[];
        
        callerStream.listen((candidates) {
          if (candidates.isNotEmpty) callerCandidates.add(candidates);
        });
        
        calleeStream.listen((candidates) {
          if (candidates.isNotEmpty) calleeCandidates.add(candidates);
        });

        // Act
        await dataSource.addIceCandidate(roomId, 'caller', callerCandidate);
        await dataSource.addIceCandidate(roomId, 'callee', calleeCandidate);
        
        // Wait for streams to emit
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(callerCandidates, hasLength(1));
        expect(calleeCandidates, hasLength(1));
        expect(callerCandidates.first.first.candidate, equals('caller-candidate'));
        expect(calleeCandidates.first.first.candidate, equals('callee-candidate'));
      });

      test('should throw exception when adding candidate to non-existent room', () async {
        // Arrange
        final candidate = IceCandidateModel(
          candidate: 'test-candidate',
          sdpMid: 'data',
          sdpMLineIndex: 0,
          timestamp: DateTime.now(),
        );

        // Act & Assert
        expect(
          () => dataSource.addIceCandidate('non-existent-room', 'caller', candidate),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('roomExists', () {
      test('should return true for existing room', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(offer);

        // Act & Assert
        expect(await dataSource.roomExists(roomId), isTrue);
      });

      test('should return false for non-existent room', () async {
        // Act & Assert
        expect(await dataSource.roomExists('non-existent-room'), isFalse);
      });
    });

    group('clearRoom', () {
      test('should clear room and complete streams', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(offer);
        
        final answerStream = dataSource.watchAnswer(roomId);
        final candidatesStream = dataSource.watchIceCandidates(roomId, 'caller');
        
        bool answerStreamCompleted = false;
        bool candidatesStreamCompleted = false;
        
        answerStream.listen(
          (data) {},
          onDone: () => answerStreamCompleted = true,
        );
        
        candidatesStream.listen(
          (data) {},
          onDone: () => candidatesStreamCompleted = true,
        );

        // Act
        await dataSource.clearRoom(roomId);

        // Give streams time to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(await dataSource.roomExists(roomId), isFalse);
        expect(answerStreamCompleted, isTrue);
        expect(candidatesStreamCompleted, isTrue);
      });
    });

    group('multiple candidates accumulation', () {
      test('should accumulate multiple ICE candidates for same role', () async {
        // Arrange
        final offer = OfferData(
          sdp: 'test-sdp',
          type: 'offer',
          timestamp: DateTime.now(),
        );
        final roomId = await dataSource.createRoom(offer);
        
        final candidate1 = IceCandidateModel(
          candidate: 'candidate-1',
          sdpMid: 'data',
          sdpMLineIndex: 0,
          timestamp: DateTime.now(),
        );
        
        final candidate2 = IceCandidateModel(
          candidate: 'candidate-2',
          sdpMid: 'data',
          sdpMLineIndex: 0,
          timestamp: DateTime.now(),
        );

        final candidatesStream = dataSource.watchIceCandidates(roomId, 'caller');
        final emittedCandidatesLists = <List<IceCandidateModel>>[];
        
        candidatesStream.listen((candidates) {
          if (candidates.isNotEmpty) {
            emittedCandidatesLists.add(List.from(candidates));
          }
        });

        // Act
        await dataSource.addIceCandidate(roomId, 'caller', candidate1);
        await dataSource.addIceCandidate(roomId, 'caller', candidate2);
        
        // Wait for streams to emit
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(emittedCandidatesLists, hasLength(2));
        expect(emittedCandidatesLists[0], hasLength(1));
        expect(emittedCandidatesLists[1], hasLength(2));
        expect(emittedCandidatesLists[1].last.candidate, equals('candidate-2'));
      });
    });
  });
}
