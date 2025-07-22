import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_state.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_event.dart';

// Bloc
class RoomSelectionLocalBloc
    extends Bloc<RoomSelectionEvent, RoomSelectionState> {
  final SignalingDataSource _signalingDataSource;
  final Logger _logger = Logger();
  StreamSubscription<AnswerData?>? _answerSubscription;

  RoomSelectionLocalBloc({required SignalingDataSource signalingDataSource})
    : _signalingDataSource = signalingDataSource,
      super(const RoomSelectionState.idle()) {
    on<CreateRequested>(_onCreateRequested);
    on<JoinRequested>(_onJoinRequested);
    on<ClearRequested>(_onClearRequested);
  }

  Future<void> _onCreateRequested(
    CreateRequested event,
    Emitter<RoomSelectionState> emit,
  ) async {
    try {
      _logger.i('Creating new room as caller...');
      emit(const RoomSelectionState.creating());

      // Create a dummy offer for room creation
      final offer = OfferData(
        sdp: 'dummy-sdp-${DateTime.now().millisecondsSinceEpoch}',
        type: 'offer',
        timestamp: DateTime.now(),
      );

      final roomId = await _signalingDataSource.createRoom(offer);
      _logger.i('Room created successfully: $roomId');

      // Start watching for answer
      _answerSubscription = _signalingDataSource.watchAnswer(roomId).listen(
        (answer) {
          if (answer != null) {
            _logger.i('Answer received for room: $roomId');
            emit(RoomSelectionState.connected(roomId: roomId, isCaller: true));
            _answerSubscription?.cancel();
          }
        },
        onError: (error) {
          _logger.e('Error watching answer: $error');
          emit(RoomSelectionState.failure(message: 'Error watching for answer: $error'));
        },
      );

      emit(RoomSelectionState.waitingAnswer(roomId: roomId));
    } catch (error) {
      _logger.e('Failed to create room: $error');
      emit(RoomSelectionState.failure(message: 'Failed to create room: ${error.toString()}'));
    }
  }

  Future<void> _onJoinRequested(
    JoinRequested event,
    Emitter<RoomSelectionState> emit,
  ) async {
    try {
      _logger.i('Joining room as callee: ${event.roomId}');
      emit(RoomSelectionState.joining(roomId: event.roomId));

      // Check if room exists
      final roomExists = await _signalingDataSource.roomExists(event.roomId);
      if (!roomExists) {
        throw Exception('Room not found: ${event.roomId}');
      }

      // Fetch offer from the room to validate it exists
      await _signalingDataSource.fetchOffer(event.roomId);
      _logger.i('Offer validated successfully for room: ${event.roomId}');

      // Create a dummy answer 
      final answer = AnswerData(
        sdp: 'dummy-answer-sdp-${DateTime.now().millisecondsSinceEpoch}',
        type: 'answer',
        timestamp: DateTime.now(),
      );

      // Save answer to the room
      await _signalingDataSource.saveAnswer(event.roomId, answer);
      _logger.i('Answer saved successfully for room: ${event.roomId}');

      _logger.i('Successfully joined room: ${event.roomId}');
      emit(RoomSelectionState.connected(roomId: event.roomId, isCaller: false));
    } catch (error) {
      _logger.e('Failed to join room ${event.roomId}: $error');
      emit(RoomSelectionState.failure(message: 'Failed to join room: ${error.toString()}'));
    }
  }

  Future<void> _onClearRequested(
    ClearRequested event,
    Emitter<RoomSelectionState> emit,
  ) async {
    _logger.i('Clearing room selection state');
    await _answerSubscription?.cancel();
    _answerSubscription = null;
    emit(const RoomSelectionState.idle());
  }

  @override
  Future<void> close() async {
    await _answerSubscription?.cancel();
    return super.close();
  }
}
