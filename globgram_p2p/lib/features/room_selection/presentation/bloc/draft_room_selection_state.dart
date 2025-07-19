// TODO: Phase 5 – Replace legacy state classes with this
// Draft Freezed implementation for RoomSelectionState
// This provides type-safe state management with immutable data structures

// TODO: Generate with: flutter packages pub run build_runner build
// Once generated, uncomment the following:

/*
import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_room_selection_state.freezed.dart';

@freezed
class DraftRoomSelectionState with _$DraftRoomSelectionState {
  const factory DraftRoomSelectionState.initial() = DraftRoomInitial;
  
  const factory DraftRoomSelectionState.creating() = DraftRoomCreating;
  
  const factory DraftRoomSelectionState.waitingAnswer({
    required String roomId,
    @Default(true) bool isCaller,
  }) = DraftRoomWaitingAnswer;
  
  const factory DraftRoomSelectionState.connecting({
    required String roomId,
    @Default(false) bool isCaller,
  }) = DraftRoomConnecting;
  
  const factory DraftRoomSelectionState.connected({
    required String roomId,
    @Default(false) bool isCaller,
  }) = DraftRoomConnected;
  
  const factory DraftRoomSelectionState.error({
    required String message,
  }) = DraftRoomError;
}

@freezed
class DraftRoomSelectionEvent with _$DraftRoomSelectionEvent {
  const factory DraftRoomSelectionEvent.createRequested() = DraftCreateRequested;
  
  const factory DraftRoomSelectionEvent.joinRequested({
    required String roomId,
  }) = DraftJoinRequested;
  
  const factory DraftRoomSelectionEvent.clearRequested() = DraftClearRequested;
}
*/
