import 'dart:async';
import 'chat_message.dart';
// TODO: Import MediaStream from flutter_webrtc when media features are implemented
// import 'package:flutter_webrtc/flutter_webrtc.dart';

enum ConnectionState { disconnected, connecting, connected, failed }

abstract class WebRTCService {
  // Public streams
  Stream<ConnectionState> get connectionState$;
  Stream<ChatMessage> get messages$;
  
  // TODO: Future media streams - uncomment when implementing media features
  // Stream<MediaStream> get localStream$;
  // Stream<MediaStream> get remoteStream$;

  // Core methods
  Future<void> createConnection({required bool isCaller, required String roomId});
  Future<void> sendText(String text);
  Future<void> dispose();
  
  // TODO: Future media methods - uncomment when implementing media features
  // Future<void> prepareMedia({bool audio = true, bool video = false});
  // Future<void> stopMedia();
  // Future<void> toggleAudio();
  // Future<void> toggleVideo();
  
  // Debug methods
  String getDebugInfo();
}
