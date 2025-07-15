import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_bloc.dart';

// Mock class for RoomRemoteDataSource
class MockRoomRemoteDataSource extends Mock implements RoomRemoteDataSource {}

// Mock class for HydratedStorage
class MockHydratedStorage extends Mock implements Storage {}

void main() {
  group('RoomSelectionBloc', () {
    late RoomSelectionBloc roomSelectionBloc;
    late MockRoomRemoteDataSource mockRoomDataSource;
    late FakeFirebaseFirestore fakeFirestore;
    late MockHydratedStorage mockStorage;

    setUpAll(() {
      // Initialize HydratedBloc storage for testing
      mockStorage = MockHydratedStorage();
      when(() => mockStorage.read(any())).thenReturn(null);
      when(() => mockStorage.write(any(), any())).thenAnswer((_) async {});
      when(() => mockStorage.delete(any())).thenAnswer((_) async {});
      when(() => mockStorage.clear()).thenAnswer((_) async {});
      HydratedBloc.storage = mockStorage;
    });

    setUp(() {
      mockRoomDataSource = MockRoomRemoteDataSource();
      fakeFirestore = FakeFirebaseFirestore();
      roomSelectionBloc = RoomSelectionBloc(
        roomDataSource: mockRoomDataSource,
      );
    });

    tearDown(() {
      roomSelectionBloc.close();
    });

    test('initial state is RoomInitial', () {
      expect(roomSelectionBloc.state, equals(const RoomInitial()));
    });

    group('CreateRequested', () {
      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'emits [RoomCreating, RoomWaitingAnswer] when create room succeeds',
        setUp: () {
          when(() => mockRoomDataSource.createRoom())
              .thenAnswer((_) async => 'ROOM123');
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const CreateRequested()),
        expect: () => [
          const RoomCreating(),
          const RoomWaitingAnswer('ROOM123'),
        ],
        verify: (_) {
          verify(() => mockRoomDataSource.createRoom()).called(1);
        },
      );

      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'emits [RoomCreating, RoomError] when create room fails',
        setUp: () {
          when(() => mockRoomDataSource.createRoom())
              .thenThrow(Exception('Network error'));
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const CreateRequested()),
        expect: () => [
          const RoomCreating(),
          const RoomError('Failed to create room: Exception: Network error'),
        ],
        verify: (_) {
          verify(() => mockRoomDataSource.createRoom()).called(1);
        },
      );
    });

    group('JoinRequested', () {
      const testRoomId = 'ROOM456';

      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'emits [RoomConnecting, RoomConnected] when join room succeeds',
        setUp: () {
          when(() => mockRoomDataSource.joinRoom(testRoomId))
              .thenAnswer((_) async {});
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const JoinRequested(testRoomId)),
        expect: () => [
          const RoomConnecting(testRoomId),
          const RoomConnected(testRoomId),
        ],
        verify: (_) {
          verify(() => mockRoomDataSource.joinRoom(testRoomId)).called(1);
        },
      );

      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'emits [RoomConnecting, RoomError] when join room fails',
        setUp: () {
          when(() => mockRoomDataSource.joinRoom(testRoomId))
              .thenThrow(Exception('Room not found'));
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const JoinRequested(testRoomId)),
        expect: () => [
          const RoomConnecting(testRoomId),
          const RoomError('Failed to join room: Exception: Room not found'),
        ],
        verify: (_) {
          verify(() => mockRoomDataSource.joinRoom(testRoomId)).called(1);
        },
      );

      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'emits [RoomConnecting, RoomError] when room does not exist',
        setUp: () {
          when(() => mockRoomDataSource.joinRoom('INVALID'))
              .thenThrow(Exception('Room not found: INVALID'));
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const JoinRequested('INVALID')),
        expect: () => [
          const RoomConnecting('INVALID'),
          const RoomError('Failed to join room: Exception: Room not found: INVALID'),
        ],
        verify: (_) {
          verify(() => mockRoomDataSource.joinRoom('INVALID')).called(1);
        },
      );
    });

    group('ClearRequested', () {
      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'emits [RoomInitial] when clear is requested',
        build: () => roomSelectionBloc,
        seed: () => const RoomError('Some error'),
        act: (bloc) => bloc.add(const ClearRequested()),
        expect: () => [
          const RoomInitial(),
        ],
      );

      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'emits [RoomInitial] when clear is requested from connected state',
        build: () => roomSelectionBloc,
        seed: () => const RoomConnected('ROOM789'),
        act: (bloc) => bloc.add(const ClearRequested()),
        expect: () => [
          const RoomInitial(),
        ],
      );
    });

    group('State persistence', () {
      test('fromJson returns correct state for RoomInitial', () {
        final json = {'type': 'RoomInitial'};
        final state = roomSelectionBloc.fromJson(json);
        expect(state, equals(const RoomInitial()));
      });

      test('fromJson returns correct state for RoomWaitingAnswer', () {
        final json = {'type': 'RoomWaitingAnswer', 'roomId': 'ROOM123'};
        final state = roomSelectionBloc.fromJson(json);
        expect(state, equals(const RoomWaitingAnswer('ROOM123')));
      });

      test('fromJson returns correct state for RoomConnected', () {
        final json = {'type': 'RoomConnected', 'roomId': 'ROOM456'};
        final state = roomSelectionBloc.fromJson(json);
        expect(state, equals(const RoomConnected('ROOM456')));
      });

      test('fromJson returns correct state for RoomError', () {
        final json = {'type': 'RoomError', 'message': 'Test error'};
        final state = roomSelectionBloc.fromJson(json);
        expect(state, equals(const RoomError('Test error')));
      });

      test('fromJson returns null for invalid json', () {
        final json = {'type': 'InvalidType'};
        final state = roomSelectionBloc.fromJson(json);
        expect(state, isNull);
      });

      test('toJson returns correct json for RoomInitial', () {
        const state = RoomInitial();
        final json = roomSelectionBloc.toJson(state);
        expect(json, equals({'type': 'RoomInitial'}));
      });

      test('toJson returns correct json for RoomWaitingAnswer', () {
        const state = RoomWaitingAnswer('ROOM123');
        final json = roomSelectionBloc.toJson(state);
        expect(json, equals({'type': 'RoomWaitingAnswer', 'roomId': 'ROOM123'}));
      });

      test('toJson returns correct json for RoomConnected', () {
        const state = RoomConnected('ROOM456');
        final json = roomSelectionBloc.toJson(state);
        expect(json, equals({'type': 'RoomConnected', 'roomId': 'ROOM456'}));
      });

      test('toJson returns correct json for RoomError', () {
        const state = RoomError('Test error');
        final json = roomSelectionBloc.toJson(state);
        expect(json, equals({'type': 'RoomError', 'message': 'Test error'}));
      });
    });

    group('Firestore simulation scenarios', () {
      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'simulates successful room creation with Firestore',
        setUp: () async {
          // Simulate adding a room document to Firestore
          await fakeFirestore.collection('rooms').add({
            'roomId': 'FIRESTORE_ROOM',
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'status': 'waiting',
          });

          when(() => mockRoomDataSource.createRoom())
              .thenAnswer((_) async => 'FIRESTORE_ROOM');
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const CreateRequested()),
        expect: () => [
          const RoomCreating(),
          const RoomWaitingAnswer('FIRESTORE_ROOM'),
        ],
      );

      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'simulates joining existing room in Firestore',
        setUp: () async {
          // Pre-populate Firestore with existing room
          await fakeFirestore.collection('rooms').doc('EXISTING_ROOM').set({
            'roomId': 'EXISTING_ROOM',
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'status': 'waiting',
          });

          when(() => mockRoomDataSource.joinRoom('EXISTING_ROOM'))
              .thenAnswer((_) async {});
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const JoinRequested('EXISTING_ROOM')),
        expect: () => [
          const RoomConnecting('EXISTING_ROOM'),
          const RoomConnected('EXISTING_ROOM'),
        ],
      );

      blocTest<RoomSelectionBloc, RoomSelectionState>(
        'simulates joining non-existent room in Firestore',
        setUp: () {
          // Don't add any room to Firestore - simulate empty database
          when(() => mockRoomDataSource.joinRoom('NON_EXISTENT'))
              .thenThrow(Exception('Room not found: NON_EXISTENT'));
        },
        build: () => roomSelectionBloc,
        act: (bloc) => bloc.add(const JoinRequested('NON_EXISTENT')),
        expect: () => [
          const RoomConnecting('NON_EXISTENT'),
          const RoomError('Failed to join room: Exception: Room not found: NON_EXISTENT'),
        ],
      );
    });
  });
}
