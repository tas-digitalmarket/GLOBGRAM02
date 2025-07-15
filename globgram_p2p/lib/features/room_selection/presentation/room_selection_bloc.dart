import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import '../data/room_remote_data_source.dart';

// Events
abstract class RoomSelectionEvent extends Equatable {
  const RoomSelectionEvent();

  @override
  List<Object?> get props => [];
}

class CreateRequested extends RoomSelectionEvent {
  const CreateRequested();
}

class JoinRequested extends RoomSelectionEvent {
  final String roomId;

  const JoinRequested(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class ClearRequested extends RoomSelectionEvent {
  const ClearRequested();
}

// States
abstract class RoomSelectionState extends Equatable {
  const RoomSelectionState();

  @override
  List<Object?> get props => [];
}

class RoomInitial extends RoomSelectionState {
  const RoomInitial();
}

class RoomCreating extends RoomSelectionState {
  const RoomCreating();
}

class RoomWaitingAnswer extends RoomSelectionState {
  final String roomId;

  const RoomWaitingAnswer(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class RoomConnecting extends RoomSelectionState {
  final String roomId;

  const RoomConnecting(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class RoomConnected extends RoomSelectionState {
  final String roomId;

  const RoomConnected(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class RoomError extends RoomSelectionState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class RoomSelectionBloc extends HydratedBloc<RoomSelectionEvent, RoomSelectionState> {
  final RoomRemoteDataSource _roomDataSource;
  final Logger _logger = Logger();

  RoomSelectionBloc({
    required RoomRemoteDataSource roomDataSource,
  })  : _roomDataSource = roomDataSource,
        super(const RoomInitial()) {
    on<CreateRequested>(_onCreateRequested);
    on<JoinRequested>(_onJoinRequested);
    on<ClearRequested>(_onClearRequested);
  }

  Future<void> _onCreateRequested(
    CreateRequested event,
    Emitter<RoomSelectionState> emit,
  ) async {
    try {
      _logger.i('Creating new room...');
      emit(const RoomCreating());

      final roomId = await _roomDataSource.createRoom();
      _logger.i('Room created successfully: $roomId');
      
      emit(RoomWaitingAnswer(roomId));
    } catch (error) {
      _logger.e('Failed to create room: $error');
      emit(RoomError('Failed to create room: ${error.toString()}'));
    }
  }

  Future<void> _onJoinRequested(
    JoinRequested event,
    Emitter<RoomSelectionState> emit,
  ) async {
    try {
      _logger.i('Joining room: ${event.roomId}');
      emit(RoomConnecting(event.roomId));

      await _roomDataSource.joinRoom(event.roomId);
      _logger.i('Successfully joined room: ${event.roomId}');
      
      emit(RoomConnected(event.roomId));
    } catch (error) {
      _logger.e('Failed to join room ${event.roomId}: $error');
      emit(RoomError('Failed to join room: ${error.toString()}'));
    }
  }

  Future<void> _onClearRequested(
    ClearRequested event,
    Emitter<RoomSelectionState> emit,
  ) async {
    _logger.i('Clearing room selection state');
    emit(const RoomInitial());
  }

  @override
  RoomSelectionState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String?;
      
      switch (type) {
        case 'RoomInitial':
          return const RoomInitial();
        case 'RoomCreating':
          return const RoomCreating();
        case 'RoomWaitingAnswer':
          final roomId = json['roomId'] as String;
          return RoomWaitingAnswer(roomId);
        case 'RoomConnecting':
          final roomId = json['roomId'] as String;
          return RoomConnecting(roomId);
        case 'RoomConnected':
          final roomId = json['roomId'] as String;
          return RoomConnected(roomId);
        case 'RoomError':
          final message = json['message'] as String;
          return RoomError(message);
        default:
          return null;
      }
    } catch (error) {
      _logger.e('Failed to restore state from JSON: $error');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(RoomSelectionState state) {
    try {
      switch (state.runtimeType) {
        case RoomInitial:
          return {'type': 'RoomInitial'};
        case RoomCreating:
          return {'type': 'RoomCreating'};
        case RoomWaitingAnswer:
          final waitingState = state as RoomWaitingAnswer;
          return {
            'type': 'RoomWaitingAnswer',
            'roomId': waitingState.roomId,
          };
        case RoomConnecting:
          final connectingState = state as RoomConnecting;
          return {
            'type': 'RoomConnecting',
            'roomId': connectingState.roomId,
          };
        case RoomConnected:
          final connectedState = state as RoomConnected;
          return {
            'type': 'RoomConnected',
            'roomId': connectedState.roomId,
          };
        case RoomError:
          final errorState = state as RoomError;
          return {
            'type': 'RoomError',
            'message': errorState.message,
          };
        default:
          return null;
      }
    } catch (error) {
      _logger.e('Failed to serialize state to JSON: $error');
      return null;
    }
  }
}
