import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source_local.dart';

class WebRTCServiceLocal implements WebRTCService {
  static final Logger _logger = Logger();
  final RoomRemoteDataSourceLocal _localDataSource;

  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  String? _currentRoomId;
  bool _isCaller = false;

  // Stream controllers
  final StreamController<ChatMessage> _dataMessageController =
      StreamController<ChatMessage>.broadcast();
  final StreamController<ConnectionState> _connectionStateController =
      StreamController<ConnectionState>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  // ICE candidates subscription
  StreamSubscription<RTCIceCandidate>? _iceCandidatesSubscription;

  WebRTCServiceLocal(this._localDataSource);

  // Public streams
  @override
  Stream<ChatMessage> get messageStream => _dataMessageController.stream;
  @override
  Stream<ConnectionState> get connectionStateStream => _connectionStateController.stream;

  @override
  bool get isConnected => _connectionState == ConnectionState.connected;
  ConnectionState _connectionState = ConnectionState.disconnected;

  bool _isInitialized = false;

  /// Create peer connection with ICE server configuration
  Future<void> _createPeerConnection() async {
    try {
      // Use same configuration pattern as existing WebRTC service
      final configuration = {
        'iceServers': [
          {
            'urls': [
              'stun:stun1.l.google.com:19302',
              'stun:stun2.l.google.com:19302',
            ],
          },
        ],
      };

      // Create peer connection - this should work with the flutter_webrtc package
      _peerConnection = await createPeerConnection(configuration);
      _setupPeerConnectionListeners();
      
      _logger.i('Peer connection created successfully (Local)');
    } catch (e) {
      _logger.e('Failed to create peer connection: $e');
      _errorController.add('Failed to create peer connection: $e');
      rethrow;
    }
  }

  /// Initialize WebRTC as caller (creates offer)
  @override
  Future<void> initAsCaller(String roomId) async {
    try {
      _logger.i('Initializing WebRTC as caller for room: $roomId (Local)');
      
      _currentRoomId = roomId;
      _isCaller = true;
      
      await _createPeerConnection();
      await _createDataChannel();
      
      // Create and set local offer
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      
      // Store offer in local storage
      await _localDataSource.setOffer(roomId, offer);
      
      // Listen for ICE candidates from callee
      _listenToRemoteIceCandidates('callee');
      
      // Listen for answer from callee
      _listenForAnswer(roomId);
      
      _isInitialized = true;
      _updateConnectionState(ConnectionState.connecting);
      
      _logger.i('WebRTC caller initialization completed (Local)');
    } catch (e) {
      _logger.e('Failed to initialize as caller: $e');
      _errorController.add('Failed to initialize as caller: $e');
      _updateConnectionState(ConnectionState.failed);
      rethrow;
    }
  }

  /// Initialize WebRTC as callee (receives offer and creates answer)
  @override
  Future<void> initAsCallee(String roomId) async {
    try {
      _logger.i('Initializing WebRTC as callee for room: $roomId (Local)');
      
      _currentRoomId = roomId;
      _isCaller = false;
      
      await _createPeerConnection();
      
      // Set up data channel listener for incoming channels
      _peerConnection!.onDataChannel = (channel) {
        _dataChannel = channel;
        _setupDataChannelListeners();
        _logger.i('Data channel received from caller (Local)');
      };
      
      // Get offer from local storage
      final roomData = await _localDataSource.getRoomData(roomId);
      if (roomData == null || roomData['offer'] == null) {
        throw Exception('No offer found for room: $roomId');
      }
      
      final offerData = roomData['offer'] as Map<String, dynamic>;
      final offer = RTCSessionDescription(offerData['sdp'], offerData['type']);
      
      // Set remote description (offer)
      await _peerConnection!.setRemoteDescription(offer);
      
      // Create and set local answer
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      
      // Store answer in local storage
      await _localDataSource.setAnswer(roomId, answer);
      
      // Listen for ICE candidates from caller
      _listenToRemoteIceCandidates('caller');
      
      _isInitialized = true;
      _updateConnectionState(ConnectionState.connecting);
      
      _logger.i('WebRTC callee initialization completed (Local)');
    } catch (e) {
      _logger.e('Failed to initialize as callee: $e');
      _errorController.add('Failed to initialize as callee: $e');
      _updateConnectionState(ConnectionState.failed);
      rethrow;
    }
  }

  /// Create data channel for chat messages (caller only)
  Future<void> _createDataChannel() async {
    try {
      final dataChannelDict = RTCDataChannelInit()
        ..ordered = true
        ..id = 1;

      _dataChannel = await _peerConnection!.createDataChannel(
        'chat',
        dataChannelDict,
      );
      
      _setupDataChannelListeners();
      _logger.i('Data channel "chat" created (Local)');
    } catch (e) {
      _logger.e('Failed to create data channel: $e');
      _errorController.add('Failed to create data channel: $e');
      rethrow;
    }
  }

  /// Set up peer connection event listeners
  void _setupPeerConnectionListeners() {
    if (_peerConnection == null) return;

    // Connection state changes
    _peerConnection!.onConnectionState = (state) {
      _logger.i('Peer connection state changed: $state (Local)');
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
          _errorController.add('Peer connection failed');
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        case RTCPeerConnectionState.RTCPeerConnectionStateNew:
          _updateConnectionState(ConnectionState.connecting);
          break;
      }
    };

    // ICE candidate generation
    _peerConnection!.onIceCandidate = (candidate) {
      _logger.d('ICE candidate generated: ${candidate.candidate} (Local)');
      if (_currentRoomId != null) {
        _sendIceCandidate(candidate);
      }
    };

    // ICE connection state changes
    _peerConnection!.onIceConnectionState = (state) {
      _logger.i('ICE connection state: $state (Local)');
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        _errorController.add('ICE connection failed');
      }
    };
  }

  /// Set up data channel event listeners
  void _setupDataChannelListeners() {
    if (_dataChannel == null) return;

    _dataChannel!.onDataChannelState = (state) {
      _logger.i('Data channel state: $state (Local)');
      if (state == RTCDataChannelState.RTCDataChannelOpen) {
        _logger.i('Data channel is now open for messaging (Local)');
      }
    };

    _dataChannel!.onMessage = (message) {
      _logger.d('Received message: ${message.text} (Local)');
      try {
        final Map<String, dynamic> messageData = jsonDecode(message.text);
        final chatMessage = ChatMessage.fromJson(messageData);
        _dataMessageController.add(chatMessage);
      } catch (e) {
        _logger.e('Failed to parse received message: $e');
        // Fallback: create a basic message from peer
        final fallbackMessage = ChatMessage.fromPeer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: message.text,
        );
        _dataMessageController.add(fallbackMessage);
      }
    };
  }

  /// Send chat message through data channel
  @override
  Future<void> sendMessage(String text) async {
    if (!_isInitialized) {
      throw StateError('WebRTC service not initialized');
    }

    if (_dataChannel == null ||
        _dataChannel!.state != RTCDataChannelState.RTCDataChannelOpen) {
      throw StateError('Data channel not ready for sending messages');
    }

    try {
      final chatMessage = ChatMessage.fromSelf(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
      );

      final messageJson = jsonEncode(chatMessage.toJson());
      await _dataChannel!.send(RTCDataChannelMessage(messageJson));

      // Add to local stream for UI update
      _dataMessageController.add(chatMessage);

      _logger.d('Message sent successfully: $text (Local)');
    } catch (e) {
      _logger.e('Failed to send message: $e');
      _errorController.add('Failed to send message: $e');
      rethrow;
    }
  }

  /// Send ICE candidate to local storage
  Future<void> _sendIceCandidate(RTCIceCandidate candidate) async {
    if (_currentRoomId == null) return;

    try {
      final type = _isCaller ? 'caller' : 'callee';
      await _localDataSource.addIceCandidate(_currentRoomId!, type, candidate);
      _logger.d('ICE candidate sent to local storage');
    } catch (e) {
      _logger.e('Failed to send ICE candidate: $e');
      _errorController.add('Failed to send ICE candidate: $e');
    }
  }

  /// Listen to remote ICE candidates from local storage
  void _listenToRemoteIceCandidates(String remoteType) {
    if (_currentRoomId == null) return;

    _iceCandidatesSubscription = _localDataSource
        .listenIceCandidates(_currentRoomId!, remoteType)
        .listen(
      (candidate) async {
        try {
          await _peerConnection!.addCandidate(candidate);
          _logger.d('Remote ICE candidate added (Local)');
        } catch (e) {
          _logger.e('Failed to add remote ICE candidate: $e');
        }
      },
      onError: (e) {
        _logger.e('Error listening to ICE candidates: $e');
        _errorController.add('Error listening to ICE candidates: $e');
      },
    );
  }

  /// Listen for answer from callee (caller only)
  void _listenForAnswer(String roomId) {
    if (!_isCaller) return;

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final roomData = await _localDataSource.getRoomData(roomId);
        if (roomData != null && roomData['answer'] != null) {
          final answerData = roomData['answer'] as Map<String, dynamic>;
          final answer = RTCSessionDescription(answerData['sdp'], answerData['type']);
          await _peerConnection!.setRemoteDescription(answer);
          _logger.i('Answer received and set as remote description (Local)');
          timer.cancel();
        }
      } catch (e) {
        _logger.e('Error checking for answer: $e');
        if (timer.tick > 30) { // Stop after 60 seconds
          timer.cancel();
          _errorController.add('Timeout waiting for answer');
        }
      }
    });
  }

  /// Update connection state and notify listeners
  void _updateConnectionState(ConnectionState newState) {
    if (_connectionState != newState) {
      _connectionState = newState;
      _connectionStateController.add(newState);
      _logger.i('Connection state updated to: $newState (Local)');
    }
  }

  /// Dispose of all resources
  @override
  Future<void> dispose() async {
    try {
      _logger.i('Disposing WebRTC service (Local)');

      // Cancel ICE candidates subscription
      await _iceCandidatesSubscription?.cancel();

      // Close data channel
      await _dataChannel?.close();
      _dataChannel = null;

      // Close peer connection
      await _peerConnection?.close();
      _peerConnection = null;

      // Close streams
      await _dataMessageController.close();
      await _connectionStateController.close();
      await _errorController.close();

      _isInitialized = false;
      _currentRoomId = null;
      _updateConnectionState(ConnectionState.disconnected);

      _logger.i('WebRTC service disposed successfully (Local)');
    } catch (e) {
      _logger.e('Error during disposal: $e');
    }
  }
}
