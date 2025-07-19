import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';

enum ConnectionState { disconnected, connecting, connected, failed }

class WebRTCService {
  static final Logger _logger = Logger();

  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;

  final StreamController<ChatMessage> _messageController =
      StreamController<ChatMessage>.broadcast();
  final StreamController<ConnectionState> _connectionStateController =
      StreamController<ConnectionState>.broadcast();

  Stream<ChatMessage> get messageStream => _messageController.stream;
  Stream<ConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  bool get isConnected => _connectionState == ConnectionState.connected;
  ConnectionState _connectionState = ConnectionState.disconnected;

  bool _isInitialized = false;

  /// Initialize WebRTC as the caller (creates offer)
  Future<void> initAsCaller(String roomId) async {
    try {
      _logger.i('Initializing WebRTC as caller for room: $roomId');

      await _initializePeerConnection();
      await _createDataChannel();

      // TODO: Create offer and handle ICE candidates
      // final offer = await _peerConnection!.createOffer();
      // await _peerConnection!.setLocalDescription(offer);
      // _logger.i('Created offer: ${offer.sdp}');

      _isInitialized = true;
      _updateConnectionState(ConnectionState.connecting);

      _logger.i('WebRTC caller initialization completed');
    } catch (error) {
      _logger.e('Failed to initialize as caller: $error');
      _updateConnectionState(ConnectionState.failed);
      rethrow;
    }
  }

  /// Initialize WebRTC as the callee (receives offer)
  Future<void> initAsCallee(String roomId) async {
    try {
      _logger.i('Initializing WebRTC as callee for room: $roomId');

      await _initializePeerConnection();

      // TODO: Set up data channel event listener for incoming channels
      // _peerConnection!.onDataChannel = (channel) {
      //   _dataChannel = channel;
      //   _setupDataChannelListeners();
      // };

      // TODO: Handle remote offer and create answer
      // await _peerConnection!.setRemoteDescription(remoteOffer);
      // final answer = await _peerConnection!.createAnswer();
      // await _peerConnection!.setLocalDescription(answer);

      _isInitialized = true;
      _updateConnectionState(ConnectionState.connecting);

      _logger.i('WebRTC callee initialization completed');
    } catch (error) {
      _logger.e('Failed to initialize as callee: $error');
      _updateConnectionState(ConnectionState.failed);
      rethrow;
    }
  }

  /// Send a text message through the data channel
  Future<void> sendMessage(String text) async {
    if (!_isInitialized) {
      throw StateError('WebRTC service not initialized');
    }

    if (_dataChannel == null ||
        _dataChannel!.state != RTCDataChannelState.RTCDataChannelOpen) {
      throw StateError('Data channel not ready for sending messages');
    }

    try {
      // Create ChatMessage from self
      final chatMessage = ChatMessage.fromSelf(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
      );

      _logger.d('Sending message: $text');

      // Convert to JSON and send
      final messageJson = jsonEncode(chatMessage.toJson());
      await _dataChannel!.send(RTCDataChannelMessage(messageJson));

      // Add to local stream for UI update
      _messageController.add(chatMessage);

      _logger.d('Message sent successfully');
    } catch (error) {
      _logger.e('Failed to send message: $error');
      rethrow;
    }
  }

  /// Initialize the peer connection with ICE servers
  Future<void> _initializePeerConnection() async {
    final configuration = {
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302',
          ],
        },
        // TODO: Add TURN servers for better connectivity
        // {
        //   'urls': 'turn:your-turn-server.com:3478',
        //   'username': 'username',
        //   'credential': 'password',
        // },
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    // Set up connection state listener
    _peerConnection!.onConnectionState = (state) {
      _logger.i('Peer connection state changed: $state');
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          _updateConnectionState(ConnectionState.connected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          _updateConnectionState(ConnectionState.disconnected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          _updateConnectionState(ConnectionState.failed);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        case RTCPeerConnectionState.RTCPeerConnectionStateNew:
          _updateConnectionState(ConnectionState.connecting);
          break;
      }
    };

    // TODO: Set up ICE candidate listener
    _peerConnection!.onIceCandidate = (candidate) {
      _logger.d('ICE candidate generated: ${candidate.candidate}');
      // TODO: Send ICE candidate to remote peer through signaling
    };

    // TODO: Set up ICE connection state listener
    _peerConnection!.onIceConnectionState = (state) {
      _logger.i('ICE connection state: $state');
    };

    _logger.i('Peer connection initialized');
  }

  /// Create data channel for text messaging
  Future<void> _createDataChannel() async {
    final dataChannelDict = RTCDataChannelInit()
      ..ordered = true
      ..id = 1;

    _dataChannel = await _peerConnection!.createDataChannel(
      'messages',
      dataChannelDict,
    );
    _setupDataChannelListeners();

    _logger.i('Data channel created');
  }

  /// Set up data channel event listeners
  void _setupDataChannelListeners() {
    if (_dataChannel == null) return;

    _dataChannel!.onDataChannelState = (state) {
      _logger.i('Data channel state: $state');
    };

    _dataChannel!.onMessage = (message) {
      _logger.d('Received message: ${message.text}');
      try {
        final Map<String, dynamic> messageData = jsonDecode(message.text);
        final chatMessage = ChatMessage.fromJson(messageData);
        _messageController.add(chatMessage);
      } catch (e) {
        _logger.e('Failed to parse received message: $e');
        // Fallback: create a basic message from peer
        final fallbackMessage = ChatMessage.fromPeer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: message.text,
        );
        _messageController.add(fallbackMessage);
      }
    };

    _logger.i('Data channel listeners set up');
  }

  /// Update connection state and notify listeners
  void _updateConnectionState(ConnectionState newState) {
    if (_connectionState != newState) {
      _connectionState = newState;
      _connectionStateController.add(newState);
      _logger.i('Connection state updated to: $newState');
    }
  }

  /// Add ICE candidate to peer connection
  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    if (_peerConnection == null) {
      throw StateError('Peer connection not initialized');
    }

    try {
      await _peerConnection!.addCandidate(candidate);
      _logger.d('ICE candidate added successfully');
    } catch (error) {
      _logger.e('Failed to add ICE candidate: $error');
      rethrow;
    }
  }

  /// Set remote description (offer or answer)
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    if (_peerConnection == null) {
      throw StateError('Peer connection not initialized');
    }

    try {
      await _peerConnection!.setRemoteDescription(description);
      _logger.i('Remote description set successfully');
    } catch (error) {
      _logger.e('Failed to set remote description: $error');
      rethrow;
    }
  }

  /// Get local description (after creating offer or answer)
  Future<RTCSessionDescription?> getLocalDescription() async =>
      await _peerConnection?.getLocalDescription();

  /// Dispose of all resources
  Future<void> dispose() async {
    try {
      _logger.i('Disposing WebRTC service');

      // Close data channel
      await _dataChannel?.close();
      _dataChannel = null;

      // Close peer connection
      await _peerConnection?.close();
      _peerConnection = null;

      // Close streams
      await _messageController.close();
      await _connectionStateController.close();

      _isInitialized = false;
      _updateConnectionState(ConnectionState.disconnected);

      _logger.i('WebRTC service disposed successfully');
    } catch (error) {
      _logger.e('Error during disposal: $error');
    }
  }
}
