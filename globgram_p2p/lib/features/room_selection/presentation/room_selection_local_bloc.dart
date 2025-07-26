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
  Timer? _timeoutTimer;

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
      _logger.i('Initiating room creation as caller...');
      emit(const RoomSelectionState.creating());

      // Generate a simple room ID - WebRTC service will handle the actual room creation
      final roomId = DateTime.now().millisecondsSinceEpoch.toString();
      
      _logger.i('Generated room ID: $roomId');
      
      _logger.i('Emitting connected state for room: $roomId');
      emit(RoomSelectionState.connected(roomId: roomId, isCaller: true));
      _logger.i('Connected state emitted successfully');
    } catch (error) {
      _logger.e('Failed to initiate room creation: $error');
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

      // Real answer will be created by WebRTC service when joining
      // For now we just mark the room as connected - WebRTC service will handle the actual connection
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
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    emit(const RoomSelectionState.idle());
  }

  @override
  Future<void> close() async {
    await _answerSubscription?.cancel();
    _timeoutTimer?.cancel();
    return super.close();
  }
}
