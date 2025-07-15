import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import '../data/webrtc_service_mock.dart';
import '../domain/chat_message.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class MessageSent extends ChatEvent {
  final String text;

  const MessageSent(this.text);

  @override
  List<Object?> get props => [text];

  @override
  String toString() => 'MessageSent { text: $text }';
}

class MessageReceived extends ChatEvent {
  final ChatMessage message;

  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'MessageReceived { message: $message }';
}

class ConnectionStateChanged extends ChatEvent {
  final ConnectionState status;

  const ConnectionStateChanged(this.status);

  @override
  List<Object?> get props => [status];

  @override
  String toString() => 'ConnectionStateChanged { status: $status }';
}

class ChatInitialized extends ChatEvent {
  const ChatInitialized();

  @override
  String toString() => 'ChatInitialized';
}

class ChatDisposed extends ChatEvent {
  const ChatDisposed();

  @override
  String toString() => 'ChatDisposed';
}

// States
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();

  @override
  String toString() => 'ChatInitial';
}

class ChatConnecting extends ChatState {
  const ChatConnecting();

  @override
  String toString() => 'ChatConnecting';
}

class ChatReady extends ChatState {
  final List<ChatMessage> history;

  const ChatReady(this.history);

  @override
  List<Object?> get props => [history];

  @override
  String toString() => 'ChatReady { messages: ${history.length} }';

  ChatReady copyWith({List<ChatMessage>? history}) {
    return ChatReady(history ?? this.history);
  }
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ChatError { message: $message }';
}

// ChatBloc
class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  static final Logger _logger = Logger();
  final WebRTCService _webrtcService;
  late StreamSubscription<ChatMessage> _messageSubscription;
  late StreamSubscription<ConnectionState> _connectionSubscription;

  ChatBloc(this._webrtcService) : super(const ChatInitial()) {
    // Register event handlers
    on<ChatInitialized>(_onChatInitialized);
    on<MessageSent>(_onMessageSent);
    on<MessageReceived>(_onMessageReceived);
    on<ConnectionStateChanged>(_onConnectionStateChanged);
    on<ChatDisposed>(_onChatDisposed);

    // Initialize the chat
    add(const ChatInitialized());
  }

  // Event Handlers
  Future<void> _onChatInitialized(
    ChatInitialized event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.i('Initializing ChatBloc');

      // Set up stream subscriptions
      _messageSubscription = _webrtcService.messageStream.listen(
        (message) {
          add(MessageReceived(message));
        },
        onError: (error) {
          _logger.e('Message stream error: $error');
          add(const ConnectionStateChanged(ConnectionState.failed));
        },
      );

      _connectionSubscription = _webrtcService.connectionStateStream.listen(
        (connectionState) {
          add(ConnectionStateChanged(connectionState));
        },
        onError: (error) {
          _logger.e('Connection stream error: $error');
          add(const ConnectionStateChanged(ConnectionState.failed));
        },
      );

      // Start with connecting state if not already connected
      if (_webrtcService.isConnected) {
        emit(ChatReady(_getCurrentMessages()));
      } else {
        emit(const ChatConnecting());
      }

      _logger.i('ChatBloc initialized successfully');
    } catch (error) {
      _logger.e('Failed to initialize ChatBloc: $error');
      emit(ChatError('Failed to initialize chat: $error'));
    }
  }

  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.d('Sending message: ${event.text}');

      // Send message through WebRTC service
      await _webrtcService.sendMessage(event.text);

      // Note: The message will be added to history automatically
      // through the WebRTC service's message stream when sendMessage
      // adds it to the stream controller

      _logger.d('Message sent successfully');
    } catch (error) {
      _logger.e('Failed to send message: $error');
      emit(ChatError('Failed to send message: $error'));
    }
  }

  Future<void> _onMessageReceived(
    MessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.d('Message received: ${event.message.text}');

      final currentState = state;
      if (currentState is ChatReady) {
        // Add new message to history
        final updatedHistory = List<ChatMessage>.from(currentState.history)
          ..add(event.message);

        emit(ChatReady(updatedHistory));
      } else {
        // If not in ready state, create new ready state with this message
        emit(ChatReady([event.message]));
      }

      _logger.d('Message added to history');
    } catch (error) {
      _logger.e('Failed to handle received message: $error');
      emit(ChatError('Failed to handle received message: $error'));
    }
  }

  Future<void> _onConnectionStateChanged(
    ConnectionStateChanged event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.i('Connection state changed to: ${event.status}');

      switch (event.status) {
        case ConnectionState.disconnected:
          emit(const ChatInitial());
          break;
        case ConnectionState.connecting:
          emit(const ChatConnecting());
          break;
        case ConnectionState.connected:
          // Preserve message history when becoming ready
          final currentMessages = _getCurrentMessages();
          emit(ChatReady(currentMessages));
          break;
        case ConnectionState.failed:
          emit(const ChatError('Connection failed'));
          break;
      }
    } catch (error) {
      _logger.e('Failed to handle connection state change: $error');
      emit(ChatError('Failed to handle connection state change: $error'));
    }
  }

  Future<void> _onChatDisposed(
    ChatDisposed event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.i('Disposing ChatBloc');

      // Cancel subscriptions
      await _messageSubscription.cancel();
      await _connectionSubscription.cancel();

      // Dispose WebRTC service
      await _webrtcService.dispose();

      emit(const ChatInitial());

      _logger.i('ChatBloc disposed successfully');
    } catch (error) {
      _logger.e('Error disposing ChatBloc: $error');
    }
  }

  // Helper Methods
  List<ChatMessage> _getCurrentMessages() {
    final currentState = state;
    if (currentState is ChatReady) {
      return currentState.history;
    }
    return [];
  }

  // Public Methods
  void sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      add(MessageSent(text.trim()));
    }
  }

  void initializeConnection(String roomId, {bool asCaller = true}) async {
    try {
      if (asCaller) {
        await _webrtcService.initAsCaller(roomId);
      } else {
        await _webrtcService.initAsCallee(roomId);
      }
    } catch (error) {
      add(const ConnectionStateChanged(ConnectionState.failed));
    }
  }

  void disposeChat() {
    add(const ChatDisposed());
  }

  // HydratedBloc Implementation
  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String?;
      switch (type) {
        case 'ChatInitial':
          return const ChatInitial();
        case 'ChatConnecting':
          return const ChatConnecting();
        case 'ChatReady':
          final historyJson = json['history'] as List<dynamic>?;
          final history =
              historyJson
                  ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [];
          return ChatReady(history);
        case 'ChatError':
          final message = json['message'] as String? ?? 'Unknown error';
          return ChatError(message);
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
      return switch (state) {
        ChatInitial _ => {'type': 'ChatInitial'},
        ChatConnecting _ => {'type': 'ChatConnecting'},
        ChatReady readyState => {
            'type': 'ChatReady',
            'history': readyState.history.map((e) => e.toJson()).toList(),
          },
        ChatError errorState => {
            'type': 'ChatError',
            'message': errorState.message,
          },
        _ => null,
      };
    } catch (error) {
      _logger.e('Error serializing ChatState: $error');
      return null;
    }
  }

  @override
  Future<void> close() async {
    // Clean up subscriptions before closing
    try {
      await _messageSubscription.cancel();
      await _connectionSubscription.cancel();
    } catch (error) {
      _logger.e('Error cleaning up subscriptions: $error');
    }
    return super.close();
  }
}
