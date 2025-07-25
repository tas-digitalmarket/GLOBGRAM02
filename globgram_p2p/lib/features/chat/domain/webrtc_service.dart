import 'dart:async';
import 'chat_message.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum ConnectionState { disconnected, connecting, connected, failed }

abstract class WebRTCService {
  // Public streams
  Stream<ConnectionState> get connectionState$;
  Stream<ChatMessage> get messages$;
  
  // Media streams for video/audio support
  Stream<MediaStream> get localStream$;
  Stream<MediaStream> get remoteStream$;

  // Core methods
  Future<String> createConnection({required bool isCaller, required String roomId});
  Future<void> sendText(String text);
  Future<void> dispose();
  
  // Media methods for video/audio support
  Future<void> prepareMedia({bool audio = true, bool video = false});
  Future<void> stopMedia();
  Future<void> toggleAudio();
  Future<void> toggleVideo();
  
  // Debug methods
  String getDebugInfo();
}
