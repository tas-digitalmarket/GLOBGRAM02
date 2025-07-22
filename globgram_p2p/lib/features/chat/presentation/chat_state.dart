import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = ChatStateInitial;
  
  const factory ChatState.connecting({
    required String roomId,
    required bool isCaller,
  }) = ChatStateConnecting;
  
  const factory ChatState.connected({
    required String roomId,
    required bool isCaller,
    required List<ChatMessage> messages,
  }) = ChatStateConnected;
  
  const factory ChatState.error({
    required String message,
  }) = ChatStateError;
  
  const factory ChatState.disconnected() = ChatStateDisconnected;
}
