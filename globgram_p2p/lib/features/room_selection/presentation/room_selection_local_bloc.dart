import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source_local.dart';

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
  final bool isCaller;

  const RoomWaitingAnswer(this.roomId, {this.isCaller = true});

  @override
  List<Object?> get props => [roomId, isCaller];
}

class RoomConnecting extends RoomSelectionState {
  final String roomId;
  final bool isCaller;

  const RoomConnecting(this.roomId, {this.isCaller = false});

  @override
  List<Object?> get props => [roomId, isCaller];
}

class RoomConnected extends RoomSelectionState {
  final String roomId;
  final bool isCaller;

  const RoomConnected(this.roomId, {this.isCaller = false});

  @override
  List<Object?> get props => [roomId, isCaller];
}

class RoomError extends RoomSelectionState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class RoomSelectionLocalBloc
    extends Bloc<RoomSelectionEvent, RoomSelectionState> {
  final RoomRemoteDataSourceLocal _localDataSource;
  final Logger _logger = Logger();

  RoomSelectionLocalBloc({required RoomRemoteDataSourceLocal localDataSource})
    : _localDataSource = localDataSource,
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
      _logger.i('Creating new room as caller (Local)...');
      emit(const RoomCreating());

      final roomId = await _localDataSource.createRoom();
      _logger.i('Room created successfully (Local): $roomId');

      emit(RoomWaitingAnswer(roomId, isCaller: true));
    } catch (error) {
      _logger.e('Failed to create room (Local): $error');
      emit(RoomError('Failed to create room: ${error.toString()}'));
    }
  }

  Future<void> _onJoinRequested(
    JoinRequested event,
    Emitter<RoomSelectionState> emit,
  ) async {
    try {
      _logger.i('Joining room as callee (Local): ${event.roomId}');
      emit(RoomConnecting(event.roomId, isCaller: false));

      // Check if room exists
      final roomData = await _localDataSource.getRoomData(event.roomId);
      if (roomData == null) {
        throw Exception('Room not found: ${event.roomId}');
      }

      _logger.i('Successfully joined room (Local): ${event.roomId}');
      emit(RoomConnected(event.roomId, isCaller: false));
    } catch (error) {
      _logger.e('Failed to join room (Local) ${event.roomId}: $error');
      emit(RoomError('Failed to join room: ${error.toString()}'));
    }
  }

  Future<void> _onClearRequested(
    ClearRequested event,
    Emitter<RoomSelectionState> emit,
  ) async {
    _logger.i('Clearing room selection state (Local)');
    emit(const RoomInitial());
  }
}
