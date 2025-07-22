import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.initializeConnection({
    required String roomId,
    required bool isCaller,
  }) = ChatInitializeConnection;
  
  const factory ChatEvent.sendMessage({
    required String text,
  }) = ChatSendMessage;
  
  const factory ChatEvent.messageReceived({
    required dynamic message,
  }) = ChatMessageReceived;
  
  const factory ChatEvent.connectionStateChanged({
    required dynamic connectionState,
  }) = ChatConnectionStateChanged;
  
  const factory ChatEvent.errorOccurred({
    required String error,
  }) = ChatErrorOccurred;
  
  const factory ChatEvent.dispose() = ChatDispose;
}
