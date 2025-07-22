import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_selection_state.freezed.dart';

@freezed
class RoomSelectionState with _$RoomSelectionState {
  const factory RoomSelectionState.idle() = RoomSelectionIdle;
  
  const factory RoomSelectionState.creating() = RoomSelectionCreating;
  
  const factory RoomSelectionState.waitingAnswer({
    required String roomId,
  }) = RoomSelectionWaitingAnswer;
  
  const factory RoomSelectionState.joining({
    required String roomId,
  }) = RoomSelectionJoining;
  
  const factory RoomSelectionState.connected({
    required String roomId,
    required bool isCaller,
  }) = RoomSelectionConnected;
  
  const factory RoomSelectionState.failure({
    required String message,
  }) = RoomSelectionFailure;
}
