import 'dart:async';
import 'chat_message.dart';

enum ConnectionState { disconnected, connecting, connected, failed }

abstract class WebRTCService {
  // Public streams
  Stream<ChatMessage> get messageStream;
  Stream<ConnectionState> get connectionStateStream;

  // Connection status
  bool get isConnected;

  // Core methods
  Future<void> initAsCaller(String roomId);
  Future<void> initAsCallee(String roomId);
  Future<void> sendMessage(String text);
  Future<void> dispose();
}
