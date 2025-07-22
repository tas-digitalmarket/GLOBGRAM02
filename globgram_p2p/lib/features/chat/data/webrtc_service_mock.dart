import 'dart:async';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';

class WebRTCServiceMock implements WebRTCService {
  static final Logger _logger = Logger();

  // Mock WebRTC connections for web testing
  dynamic _peerConnection;

  final StreamController<ChatMessage> _messageController =
      StreamController<ChatMessage>.broadcast();
  final StreamController<ConnectionState> _connectionStateController =
      StreamController<ConnectionState>.broadcast();

  // TODO: Mock media stream controllers - uncomment when implementing media features
  // final StreamController<MediaStream> _localStreamController =
  //     StreamController<MediaStream>.broadcast();
  // final StreamController<MediaStream> _remoteStreamController =
  //     StreamController<MediaStream>.broadcast();

  @override
  Stream<ChatMessage> get messages$ => _messageController.stream;
  @override
  Stream<ConnectionState> get connectionState$ =>
      _connectionStateController.stream;

  // TODO: Mock media stream getters - uncomment when implementing media features
  // @override
  // Stream<MediaStream> get localStream$ => _localStreamController.stream;
  // @override
  // Stream<MediaStream> get remoteStream$ => _remoteStreamController.stream;

  @override
  Future<void> createConnection({required bool isCaller, required String roomId}) async {
    if (isCaller) {
      await _initAsCaller(roomId);
    } else {
      await _initAsCallee(roomId);
    }
  }

  @override
  Future<void> sendText(String text) async {
    await _sendMessage(text);
  }

  // TODO: Mock media methods - uncomment when implementing media features
  /*
  @override
  Future<void> prepareMedia({bool audio = true, bool video = false}) async {
    _logger.i('Mock: Preparing media with audio=$audio, video=$video');
    // Simulate media preparation delay
    await Future.delayed(const Duration(milliseconds: 500));
    _logger.i('Mock: Media prepared successfully');
  }

  @override
  Future<void> stopMedia() async {
    _logger.i('Mock: Stopping media');
    await Future.delayed(const Duration(milliseconds: 100));
    _logger.i('Mock: Media stopped');
  }

  @override
  Future<void> toggleAudio() async {
    _logger.i('Mock: Toggling audio');
  }

  @override
  Future<void> toggleVideo() async {
    _logger.i('Mock: Toggling video');
  }
  */
  ConnectionState _connectionState = ConnectionState.disconnected;

  bool _isInitialized = false;

  /// Initialize WebRTC as the caller (creates offer)
  Future<void> _initAsCaller(String roomId) async {
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
  Future<void> _initAsCallee(String roomId) async {
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
  Future<void> _sendMessage(String text) async {
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

  /// Get debug information about peer connection
  @override
  String getDebugInfo() {
    if (_peerConnection == null) {
      return 'PeerConnection: null (MOCK MODE)';
    }
    
    return 'PeerConnection (MOCK) - Signaling: stable, ICE: connected';
  }

  /// Dispose of all resources
  @override
  Future<void> dispose() async {
    try {
      _logger.i('Disposing WebRTC service (MOCK MODE)');

      // Close peer connection
      _peerConnection = null;

      // Close stream controllers
      await _messageController.close();
      await _connectionStateController.close();

      // TODO: Close mock media stream controllers when implementing media features
      // await _localStreamController.close();
      // await _remoteStreamController.close();

      _isInitialized = false;
      _updateConnectionState(ConnectionState.disconnected);

      _logger.i('WebRTC service disposed successfully (MOCK MODE)');
    } catch (error) {
      _logger.e('Error disposing WebRTC service: $error');
    }
  }
}
