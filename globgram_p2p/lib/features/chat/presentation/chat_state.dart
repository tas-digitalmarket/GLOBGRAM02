import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = ChatStateInitial;
  
  const factory ChatState.loading({
    String? roomId,
    bool? isCaller,
    String? loadingMessage,
  }) = ChatStateLoading;
  
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
    String? roomId,
    bool? isCaller,
  }) = ChatStateError;
  
  const factory ChatState.disconnected() = ChatStateDisconnected;
  
  const factory ChatState.sendingMessage({
    required String roomId,
    required bool isCaller,
    required List<ChatMessage> messages,
    required String pendingMessage,
  }) = ChatStateSendingMessage;
}
