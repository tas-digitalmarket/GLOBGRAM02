// TODO: Phase 5 – Replace legacy state classes with this
// Draft Freezed implementation for ChatState
// This provides type-safe state management with immutable data structures

// TODO: Generate with: flutter packages pub run build_runner build
// Once generated, uncomment the following:

/*
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';

part 'draft_chat_state.freezed.dart';

@freezed
class DraftChatState with _$DraftChatState {
  const factory DraftChatState.initial() = DraftChatInitial;
  
  const factory DraftChatState.connecting() = DraftChatConnecting;
  
  const factory DraftChatState.ready({
    @Default([]) List<ChatMessage> history,
  }) = DraftChatReady;
  
  const factory DraftChatState.error({
    required String message,
  }) = DraftChatError;
}

@freezed
class DraftChatEvent with _$DraftChatEvent {
  const factory DraftChatEvent.initialized() = DraftChatInitialized;
  
  const factory DraftChatEvent.messageSent({
    required String text,
  }) = DraftMessageSent;
  
  const factory DraftChatEvent.messageReceived({
    required ChatMessage message,
  }) = DraftMessageReceived;
  
  const factory DraftChatEvent.connectionStateChanged({
    required ConnectionState status,
  }) = DraftConnectionStateChanged;
  
  const factory DraftChatEvent.disposed() = DraftChatDisposed;
}
*/
