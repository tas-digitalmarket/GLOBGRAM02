import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_state.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_event.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  static final Logger _logger = Logger();
  final WebRTCService _webrtcService;

  // Stream subscriptions
  StreamSubscription<ChatMessage>? _messageSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;

  ChatBloc(this._webrtcService) 
      : super(const ChatState.initial()) {
    on<ChatInitializeConnection>(_onInitializeConnection);
    on<ChatSendMessage>(_onSendMessage);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatConnectionStateChanged>(_onConnectionStateChanged);
    on<ChatErrorOccurred>(_onErrorOccurred);
    on<ChatDispose>(_onDispose);
  }

  Future<void> _onInitializeConnection(
    ChatInitializeConnection event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.i('Initializing chat connection for room: ${event.roomId}');
      
      // First show loading state
      emit(ChatState.loading(
        roomId: event.roomId,
        isCaller: event.isCaller,
        loadingMessage: 'Establishing connection...',
      ));

      // Brief delay to show loading state
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Then show connecting state
      emit(ChatState.connecting(
        roomId: event.roomId,
        isCaller: event.isCaller,
      ));

      // Subscribe to WebRTC service streams
      _messageSubscription = _webrtcService.messages$.listen(
        (message) => add(ChatEvent.messageReceived(message: message)),
        onError: (error) => add(ChatEvent.errorOccurred(error: error.toString())),
      );

      _connectionSubscription = _webrtcService.connectionState$.listen(
        (connectionState) => add(ChatEvent.connectionStateChanged(connectionState: connectionState)),
        onError: (error) => add(ChatEvent.errorOccurred(error: error.toString())),
      );

      // Initialize WebRTC connection
      final actualRoomId = await _webrtcService.createConnection(
        isCaller: event.isCaller,
        roomId: event.roomId,
      );

      // Update state with actual room ID if it changed (for callers)
      if (actualRoomId != event.roomId) {
        _logger.i('Room ID updated from ${event.roomId} to $actualRoomId');
        emit(ChatState.connecting(
          roomId: actualRoomId,
          isCaller: event.isCaller,
        ));
      }

      // For caller, immediately go to connected state after room creation
      if (event.isCaller) {
        _logger.i('Caller successfully created room, going to connected state');
        emit(ChatState.connected(
          roomId: actualRoomId,
          isCaller: event.isCaller,
          messages: const [],
        ));
      }

      _logger.i('Chat connection initialized successfully with room: $actualRoomId');
    } catch (error) {
      _logger.e('Failed to initialize connection: $error');
      emit(ChatState.error(
        message: 'Failed to initialize connection: $error',
        roomId: event.roomId,
        isCaller: event.isCaller,
      ));
    }
  }

  Future<void> _onSendMessage(
    ChatSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    // Only send message if we're connected
    final currentState = state;
    if (currentState is! ChatStateConnected) {
      _logger.w('Cannot send message: not connected');
      emit(ChatState.error(
        message: 'Cannot send message: not connected',
        roomId: currentState.maybeWhen(
          connecting: (roomId, isCaller) => roomId,
          loading: (roomId, isCaller, loadingMessage) => roomId,
          orElse: () => null,
        ),
        isCaller: currentState.maybeWhen(
          connecting: (roomId, isCaller) => isCaller,
          loading: (roomId, isCaller, loadingMessage) => isCaller,
          orElse: () => null,
        ),
      ));
      return;
    }

    try {
      _logger.d('Sending message: ${event.text}');
      
      // Show sending state
      emit(ChatState.sendingMessage(
        roomId: currentState.roomId,
        isCaller: currentState.isCaller,
        messages: currentState.messages,
        pendingMessage: event.text,
      ));
      
      // Send message through WebRTC service
      await _webrtcService.sendText(event.text);
      
      _logger.d('Message sent successfully');
      
      // Return to connected state (the message will be added via messageReceived event)
      emit(ChatState.connected(
        roomId: currentState.roomId,
        isCaller: currentState.isCaller,
        messages: currentState.messages,
      ));
      
    } catch (error) {
      _logger.e('Failed to send message: $error');
      final currentState = state;
      emit(ChatState.error(
        message: 'Failed to send message: $error',
        roomId: currentState.maybeWhen(
          connected: (roomId, isCaller, messages) => roomId,
          sendingMessage: (roomId, isCaller, messages, pendingMessage) => roomId,
          orElse: () => null,
        ),
        isCaller: currentState.maybeWhen(
          connected: (roomId, isCaller, messages) => isCaller,
          sendingMessage: (roomId, isCaller, messages, pendingMessage) => isCaller,
          orElse: () => null,
        ),
      ));
    }
  }

  Future<void> _onMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.d('Message received: ${event.message}');
      
      final currentState = state;
      
      if (currentState is ChatStateConnected) {
        // Add new message to existing messages
        final updatedMessages = List<ChatMessage>.from(currentState.messages)
          ..add(event.message as ChatMessage);
        
        emit(ChatState.connected(
          roomId: currentState.roomId,
          isCaller: currentState.isCaller,
          messages: updatedMessages,
        ));
      } else if (currentState is ChatStateSendingMessage) {
        // Add new message and return to connected state
        final updatedMessages = List<ChatMessage>.from(currentState.messages)
          ..add(event.message as ChatMessage);
        
        emit(ChatState.connected(
          roomId: currentState.roomId,
          isCaller: currentState.isCaller,
          messages: updatedMessages,
        ));
      } else {
        _logger.w('Received message while not in connected state: $currentState');
      }
    } catch (error) {
      _logger.e('Failed to handle received message: $error');
      final currentState = state;
      emit(ChatState.error(
        message: 'Failed to handle received message: $error',
        roomId: currentState.maybeWhen(
          connected: (roomId, isCaller, messages) => roomId,
          sendingMessage: (roomId, isCaller, messages, pendingMessage) => roomId,
          orElse: () => null,
        ),
        isCaller: currentState.maybeWhen(
          connected: (roomId, isCaller, messages) => isCaller,
          sendingMessage: (roomId, isCaller, messages, pendingMessage) => isCaller,
          orElse: () => null,
        ),
      ));
    }
  }

  Future<void> _onConnectionStateChanged(
    ChatConnectionStateChanged event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.i('Connection state changed to: ${event.connectionState}');
      
      final currentState = state;
      final connectionState = event.connectionState as ConnectionState;
      
      switch (connectionState) {
        case ConnectionState.connected:
          if (currentState is ChatStateConnecting) {
            emit(ChatState.connected(
              roomId: currentState.roomId,
              isCaller: currentState.isCaller,
              messages: const [],
            ));
          }
          break;
        case ConnectionState.disconnected:
          emit(const ChatState.disconnected());
          break;
        case ConnectionState.failed:
          emit(const ChatState.error(message: 'Connection failed'));
          break;
        case ConnectionState.connecting:
          // Keep current connecting state
          break;
      }
    } catch (error) {
      _logger.e('Failed to handle connection state change: $error');
      emit(ChatState.error(message: 'Connection state error: $error'));
    }
  }

  Future<void> _onErrorOccurred(
    ChatErrorOccurred event,
    Emitter<ChatState> emit,
  ) async {
    _logger.e('Chat error occurred: ${event.error}');
    emit(ChatState.error(message: event.error));
  }

  Future<void> _onDispose(
    ChatDispose event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.i('Disposing chat');
      
      await _messageSubscription?.cancel();
      await _connectionSubscription?.cancel();
      
      await _webrtcService.dispose();
      
      emit(const ChatState.disconnected());
      
      _logger.i('Chat disposed successfully');
    } catch (error) {
      _logger.e('Error disposing chat: $error');
    }
  }

  // Helper method to send message from UI
  void sendMessage(String text) {
    add(ChatEvent.sendMessage(text: text));
  }

  // Helper method to initialize connection from UI
  void initializeConnection({required String roomId, required bool isCaller}) {
    add(ChatEvent.initializeConnection(roomId: roomId, isCaller: isCaller));
  }

  /// Clear stored hydrated state (for manual migration)
  /// This method should be called when you want to manually reset all persisted chat data
  static Future<void> clearHydratedState() async {
    try {
      final storage = HydratedBloc.storage;
      await storage.delete('ChatBloc');
      _logger.i('ChatBloc hydrated state cleared successfully');
    } catch (error) {
      _logger.e('Error clearing ChatBloc hydrated state: $error');
    }
  }

  /// Helper method to parse boolean from JSON
  bool? _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      if (value == 'true') return true;
      if (value == 'false') return false;
    }
    return null;
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    try {
      // Check storage version for migration (v3)
      final storedVersionRaw = json['v'];
      String? storedVersion;
      if (storedVersionRaw is String) {
        storedVersion = storedVersionRaw;
      } else if (storedVersionRaw is int) {
        storedVersion = storedVersionRaw.toString();
      }
      
      if (storedVersion != '3') {
        _logger.i('Storage version mismatch (stored: $storedVersion, required: 3). Ignoring old data.');
        // Return null to ignore old data and start fresh
        return null;
      }

      final type = json['type'] as String?;
      if (type == null) return null;

      switch (type) {
        case 'initial':
          return const ChatState.initial();
        case 'loading':
          return ChatState.loading(
            roomId: json['roomId'] as String? ?? '',
            isCaller: _parseBool(json['isCaller']),
            loadingMessage: json['loadingMessage'] as String?,
          );
        case 'connecting':
          return ChatState.connecting(
            roomId: json['roomId'] as String,
            isCaller: _parseBool(json['isCaller']) ?? false,
          );
        case 'connected':
          final messagesJson = json['messages'] as List<dynamic>? ?? [];
          final messages = messagesJson
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList();
          return ChatState.connected(
            roomId: json['roomId'] as String,
            isCaller: _parseBool(json['isCaller']) ?? false,
            messages: messages,
          );
        case 'sendingMessage':
          final messagesJson = json['messages'] as List<dynamic>? ?? [];
          final messages = messagesJson
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList();
          return ChatState.sendingMessage(
            roomId: json['roomId'] as String,
            isCaller: _parseBool(json['isCaller']) ?? false,
            messages: messages,
            pendingMessage: json['pendingMessage'] as String,
          );
        case 'error':
          return ChatState.error(
            message: json['message'] as String,
            roomId: json['roomId'] as String?,
            isCaller: _parseBool(json['isCaller']),
          );
        case 'disconnected':
          return const ChatState.disconnected();
        default:
          _logger.w('Unknown state type: $type');
          return null;
      }
    } catch (error) {
      _logger.e('Error deserializing ChatState: $error');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    try {
      final baseJson = state.when(
        initial: () => {'type': 'initial'},
        loading: (roomId, isCaller, loadingMessage) => {
          'type': 'loading',
          'roomId': roomId ?? '',
          'isCaller': isCaller?.toString() ?? '',
          'loadingMessage': loadingMessage ?? '',
        },
        connecting: (roomId, isCaller) => {
          'type': 'connecting',
          'roomId': roomId,
          'isCaller': isCaller.toString(),
        },
        connected: (roomId, isCaller, messages) => {
          'type': 'connected',
          'roomId': roomId,
          'isCaller': isCaller.toString(),
          'messages': messages.map((e) => e.toJson()).toList(),
        },
        sendingMessage: (roomId, isCaller, messages, pendingMessage) => {
          'type': 'sendingMessage',
          'roomId': roomId,
          'isCaller': isCaller.toString(),
          'messages': messages.map((e) => e.toJson()).toList(),
          'pendingMessage': pendingMessage,
        },
        error: (message, roomId, isCaller) => {
          'type': 'error',
          'message': message,
          'roomId': roomId ?? '',
          'isCaller': isCaller?.toString() ?? '',
        },
        disconnected: () => {'type': 'disconnected'},
      );
      
      // Add storage version for migration management (v3)
      baseJson['v'] = '3';
      return baseJson;
    } catch (error) {
      _logger.e('Error serializing ChatState: $error');
      return null;
    }
  }

  @override
  Future<void> close() async {
    try {
      await _messageSubscription?.cancel();
      await _connectionSubscription?.cancel();
    } catch (error) {
      _logger.e('Error cleaning up subscriptions: $error');
    }
    return super.close();
  }
}
