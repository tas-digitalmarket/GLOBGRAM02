import 'dart:async';
import 'package:logger/logger.dart';
import '../domain/chat_message.dart';

enum ConnectionState { disconnected, connecting, connected, failed }

class WebRTCService {
  static final Logger _logger = Logger();

  // Mock WebRTC connections for web testing
  dynamic _peerConnection;

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
      _logger.i('Initializing WebRTC as caller for room: $roomId (MOCK MODE)');

      await _initializePeerConnection();
      await _createDataChannel();

      // TODO: Create offer and handle ICE candidates
      // final offer = await _peerConnection!.createOffer();
      // await _peerConnection!.setLocalDescription(offer);
      // _logger.i('Created offer: ${offer.sdp}');

      _isInitialized = true;
      _updateConnectionState(ConnectionState.connecting);

      // Simulate connection success after 2 seconds
      Timer(const Duration(seconds: 2), () {
        _updateConnectionState(ConnectionState.connected);
      });

      _logger.i('WebRTC caller initialization completed (MOCK MODE)');
    } catch (error) {
      _logger.e('Failed to initialize as caller: $error');
      _updateConnectionState(ConnectionState.failed);
      rethrow;
    }
  }

  /// Initialize WebRTC as the callee (receives offer)
  Future<void> initAsCallee(String roomId) async {
    try {
      _logger.i('Initializing WebRTC as callee for room: $roomId (MOCK MODE)');

      await _initializePeerConnection();

      // TODO: Set up data channel event listener for incoming channels
      // _peerConnection!.onDataChannel = (channel) {
      //   _dataChannel = channel;
      //   _setupDataChannelListeners();
      // };

      // TODO: Handle incoming offer and create answer
      // _logger.i('Ready to receive offer and create answer');

      _isInitialized = true;
      _updateConnectionState(ConnectionState.connecting);

      // Simulate connection success after 2 seconds
      Timer(const Duration(seconds: 2), () {
        _updateConnectionState(ConnectionState.connected);
      });

      _logger.i('WebRTC callee initialization completed (MOCK MODE)');
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

    if (_connectionState != ConnectionState.connected) {
      throw StateError('WebRTC not connected');
    }

    try {
      // Create ChatMessage from self
      final chatMessage = ChatMessage.fromSelf(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
      );

      _logger.d('Sending message: $text (MOCK MODE)');

      // In mock mode, just add to local stream
      _messageController.add(chatMessage);

      // Simulate receiving an echo message from peer after 1 second
      Timer(const Duration(seconds: 1), () {
        final echoMessage = ChatMessage.fromPeer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'Echo: $text',
        );
        _messageController.add(echoMessage);
      });

      _logger.d('Message sent successfully (MOCK MODE)');
    } catch (error) {
      _logger.e('Failed to send message: $error');
      rethrow;
    }
  }

  /// Initialize peer connection with STUN servers
  Future<void> _initializePeerConnection() async {
    _logger.i('Initializing peer connection (MOCK MODE)');

    // Mock initialization - no actual WebRTC setup for web compatibility
    _peerConnection = "mock_peer_connection";

    _logger.i('Peer connection initialized (MOCK MODE)');
  }

  /// Create data channel for messaging
  Future<void> _createDataChannel() async {
    if (_peerConnection == null) {
      throw StateError('Peer connection not initialized');
    }

    _logger.i('Creating data channel (MOCK MODE)');

    // Mock data channel creation
    _setupDataChannelListeners();

    _logger.i('Data channel created successfully (MOCK MODE)');
  }

  /// Set up data channel event listeners
  void _setupDataChannelListeners() {
    _logger.i('Setting up data channel listeners (MOCK MODE)');
    // Mock listeners - no actual WebRTC events for web compatibility
    _logger.i('Data channel listeners set up (MOCK MODE)');
  }

  /// Update connection state and notify listeners
  void _updateConnectionState(ConnectionState newState) {
    if (_connectionState != newState) {
      _connectionState = newState;
      _connectionStateController.add(newState);
      _logger.i('Connection state updated to: $newState');
    }
  }

  /// Get local description (after creating offer or answer)
  Future<dynamic> getLocalDescription() async {
    return "mock_local_description";
  }

  /// Dispose of all resources
  Future<void> dispose() async {
    try {
      _logger.i('Disposing WebRTC service (MOCK MODE)');

      // Close peer connection
      _peerConnection = null;

      // Close stream controllers
      await _messageController.close();
      await _connectionStateController.close();

      _isInitialized = false;
      _updateConnectionState(ConnectionState.disconnected);

      _logger.i('WebRTC service disposed successfully (MOCK MODE)');
    } catch (error) {
      _logger.e('Error disposing WebRTC service: $error');
    }
  }
}
