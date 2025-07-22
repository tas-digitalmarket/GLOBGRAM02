import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_local_bloc.dart';

// Mock class for SignalingDataSource
class MockSignalingDataSource extends Mock implements SignalingDataSource {}

// Mock class for HydratedStorage
class MockHydratedStorage extends Mock implements Storage {}

void main() {
  group('RoomSelectionLocalBloc', () {
    late RoomSelectionLocalBloc roomSelectionBloc;
    late MockSignalingDataSource mockSignalingDataSource;
    late MockHydratedStorage mockStorage;

    setUpAll(() {
      // Initialize HydratedBloc storage for testing
      mockStorage = MockHydratedStorage();
      when(() => mockStorage.read(any())).thenReturn(null);
      when(() => mockStorage.write(any(), any())).thenAnswer((_) async {});
      when(() => mockStorage.delete(any())).thenAnswer((_) async {});
      when(() => mockStorage.clear()).thenAnswer((_) async {});
      HydratedBloc.storage = mockStorage;

      // Register fallback values for mocktail
      registerFallbackValue(OfferData(
        sdp: 'test-sdp',
        type: 'offer',
        timestamp: DateTime.now(),
      ));
      registerFallbackValue(AnswerData(
        sdp: 'test-sdp',
        type: 'answer',
        timestamp: DateTime.now(),
      ));
    });

    setUp(() {
      mockSignalingDataSource = MockSignalingDataSource();
      roomSelectionBloc = RoomSelectionLocalBloc(
        signalingDataSource: mockSignalingDataSource,
      );
    });

    tearDown(() {
      roomSelectionBloc.close();
    });

    test('initial state is RoomInitial', () {
      expect(roomSelectionBloc.state, equals(const RoomInitial()));
    });

    group('CreateRequested', () {
      blocTest<RoomSelectionLocalBloc, RoomSelectionState>(
        'emits [RoomCreating, RoomWaitingAnswer] when create room succeeds',
        setUp: () {
          when(
            () => mockSignalingDataSource.createRoom(any()),
          ).thenAnswer((_) async => 'ROOM123');
          when(
            () => mockSignalingDataSource.watchAnswer('ROOM123'),
          ).thenAnswer((_) => Stream.value(null));
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const CreateRequested()),
        expect: () => [
          const RoomCreating(),
          const RoomWaitingAnswer('ROOM123', isCaller: true),
        ],
        verify: (_) {
          verify(() => mockSignalingDataSource.createRoom(any())).called(1);
          verify(() => mockSignalingDataSource.watchAnswer('ROOM123')).called(1);
        },
      );

      blocTest<RoomSelectionLocalBloc, RoomSelectionState>(
        'emits [RoomCreating, RoomError] when create room fails',
        setUp: () {
          when(
            () => mockSignalingDataSource.createRoom(any()),
          ).thenThrow(Exception('Creation failed'));
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const CreateRequested()),
        expect: () => [
          const RoomCreating(),
          const RoomError('Failed to create room: Exception: Creation failed'),
        ],
      );
    });

    group('JoinRequested', () {
      const testRoomId = 'TEST123';

      blocTest<RoomSelectionLocalBloc, RoomSelectionState>(
        'emits [RoomConnecting, RoomConnected] when join room succeeds',
        setUp: () {
          when(
            () => mockSignalingDataSource.roomExists(testRoomId),
          ).thenAnswer((_) async => true);
          when(
            () => mockSignalingDataSource.fetchOffer(testRoomId),
          ).thenAnswer((_) async => OfferData(
            sdp: 'test-offer-sdp',
            type: 'offer',
            timestamp: DateTime.now(),
          ));
          when(
            () => mockSignalingDataSource.saveAnswer(testRoomId, any()),
          ).thenAnswer((_) async {});
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const JoinRequested(testRoomId)),
        expect: () => [
          const RoomConnecting(testRoomId, isCaller: false),
          const RoomConnected(testRoomId, isCaller: false),
        ],
        verify: (_) {
          verify(() => mockSignalingDataSource.roomExists(testRoomId)).called(1);
          verify(() => mockSignalingDataSource.fetchOffer(testRoomId)).called(1);
          verify(() => mockSignalingDataSource.saveAnswer(testRoomId, any())).called(1);
        },
      );

      blocTest<RoomSelectionLocalBloc, RoomSelectionState>(
        'emits [RoomConnecting, RoomError] when room does not exist',
        setUp: () {
          when(
            () => mockSignalingDataSource.roomExists(testRoomId),
          ).thenAnswer((_) async => false);
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const JoinRequested(testRoomId)),
        expect: () => [
          const RoomConnecting(testRoomId, isCaller: false),
          const RoomError('Failed to join room: Exception: Room not found: $testRoomId'),
        ],
      );

      blocTest<RoomSelectionLocalBloc, RoomSelectionState>(
        'emits [RoomConnecting, RoomError] when join room fails',
        setUp: () {
          when(
            () => mockSignalingDataSource.roomExists(testRoomId),
          ).thenThrow(Exception('Network error'));
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const JoinRequested(testRoomId)),
        expect: () => [
          const RoomConnecting(testRoomId, isCaller: false),
          const RoomError('Failed to join room: Exception: Network error'),
        ],
      );
    });

    group('ClearRequested', () {
      blocTest<RoomSelectionLocalBloc, RoomSelectionState>(
        'emits [RoomInitial] when clear is requested',
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const ClearRequested()),
        expect: () => [
          const RoomInitial(),
        ],
      );
    });
  });
}
