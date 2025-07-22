import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_state.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_event.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  static final Logger _logger = Logger();
  final WebRTCService _webrtcService;
  final SignalingDataSource _signalingDataSource;

  // Hydration version for migration management
  static const int _currentStorageVersion = 2;
  static const String _versionKey = 'storage_version';

  // Stream subscriptions
  StreamSubscription<ChatMessage>? _messageSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;

  ChatBloc(this._webrtcService, this._signalingDataSource) 
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
      await _webrtcService.createConnection(
        isCaller: event.isCaller,
        roomId: event.roomId,
      );

      _logger.i('Chat connection initialized successfully');
    } catch (error) {
      _logger.e('Failed to initialize connection: $error');
      emit(ChatState.error(message: 'Failed to initialize connection: $error'));
    }
  }

  Future<void> _onSendMessage(
    ChatSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _logger.d('Sending message: ${event.text}');
      
      // Send message through WebRTC service
      await _webrtcService.sendText(event.text);
      
      _logger.d('Message sent successfully');
    } catch (error) {
      _logger.e('Failed to send message: $error');
      emit(ChatState.error(message: 'Failed to send message: $error'));
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
      } else {
        _logger.w('Received message while not in connected state: $currentState');
      }
    } catch (error) {
      _logger.e('Failed to handle received message: $error');
      emit(ChatState.error(message: 'Failed to handle received message: $error'));
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

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    try {
      // Check storage version for migration
      final storedVersion = json[_versionKey] as int?;
      if (storedVersion == null || storedVersion < _currentStorageVersion) {
        _logger.i('Storage version mismatch (stored: $storedVersion, current: $_currentStorageVersion). Clearing old state.');
        // Return initial state for migration - old messages will be cleared
        return const ChatState.initial();
      }

      final type = json['type'] as String?;
      if (type == null) return null;

      switch (type) {
        case 'initial':
          return const ChatState.initial();
        case 'connecting':
          return ChatState.connecting(
            roomId: json['roomId'] as String,
            isCaller: json['isCaller'] as bool,
          );
        case 'connected':
          final messagesJson = json['messages'] as List<dynamic>? ?? [];
          final messages = messagesJson
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList();
          return ChatState.connected(
            roomId: json['roomId'] as String,
            isCaller: json['isCaller'] as bool,
            messages: messages,
          );
        case 'error':
          return ChatState.error(message: json['message'] as String);
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
        connecting: (roomId, isCaller) => {
          'type': 'connecting',
          'roomId': roomId,
          'isCaller': isCaller,
        },
        connected: (roomId, isCaller, messages) => {
          'type': 'connected',
          'roomId': roomId,
          'isCaller': isCaller,
          'messages': messages.map((e) => e.toJson()).toList(),
        },
        error: (message) => {
          'type': 'error',
          'message': message,
        },
        disconnected: () => {'type': 'disconnected'},
      );
      
      // Add storage version for migration management
      baseJson[_versionKey] = _currentStorageVersion;
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
