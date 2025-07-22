import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_selection_event.freezed.dart';

@freezed
class RoomSelectionEvent with _$RoomSelectionEvent {
  const factory RoomSelectionEvent.createRequested() = CreateRequested;
  
  const factory RoomSelectionEvent.joinRequested({
    required String roomId,
  }) = JoinRequested;
  
  const factory RoomSelectionEvent.clearRequested() = ClearRequested;
}
