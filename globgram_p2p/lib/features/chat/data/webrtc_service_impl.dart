import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';

class WebRTCServiceImpl implements WebRTCService {
  static final Logger _logger = Logger();
  final SignalingDataSource _signalingDataSource;

  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  String? _currentRoomId;
  bool _isCaller = false;
  bool _isConnected = false;
  bool _sdpCleared = false;

  // TODO: Media-related state - uncomment when implementing media features
  // MediaStream? _localStream;
  // MediaStream? _remoteStream;
  // bool _audioEnabled = false;
  // bool _videoEnabled = false;
  // bool _mediaInitialized = false;

  // Stream controllers
  final StreamController<ChatMessage> _dataMessageController =
      StreamController<ChatMessage>.broadcast();
  final StreamController<ConnectionState> _connectionStateController =
      StreamController<ConnectionState>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  // TODO: Media stream controllers - uncomment when implementing media features
  // final StreamController<MediaStream> _localStreamController =
  //     StreamController<MediaStream>.broadcast();
  // final StreamController<MediaStream> _remoteStreamController =
  //     StreamController<MediaStream>.broadcast();

  // ICE candidates subscription
  StreamSubscription<List<IceCandidateModel>>? _iceCandidatesSubscription;

  WebRTCServiceImpl(this._signalingDataSource);

  // Helper methods to convert between RTCSessionDescription and SignalingDataSource models
  OfferData _rtcOfferToOfferData(RTCSessionDescription offer) {
    return OfferData(
      sdp: offer.sdp!,
      type: offer.type!,
      timestamp: DateTime.now(),
    );
  }

  AnswerData _rtcAnswerToAnswerData(RTCSessionDescription answer) {
    return AnswerData(
      sdp: answer.sdp!,
      type: answer.type!,
      timestamp: DateTime.now(),
    );
  }

  RTCSessionDescription _offerDataToRtcOffer(OfferData offer) {
    return RTCSessionDescription(offer.sdp, offer.type);
  }

  RTCSessionDescription _answerDataToRtcAnswer(AnswerData answer) {
    return RTCSessionDescription(answer.sdp, answer.type);
  }

  IceCandidateModel _rtcCandidateToModel(RTCIceCandidate candidate) {
    return IceCandidateModel(
      candidate: candidate.candidate!,
      sdpMid: candidate.sdpMid,
      sdpMLineIndex: candidate.sdpMLineIndex,
      timestamp: DateTime.now(),
    );
  }

  RTCIceCandidate _modelToRtcCandidate(IceCandidateModel model) {
    return RTCIceCandidate(
      model.candidate,
      model.sdpMid,
      model.sdpMLineIndex,
    );
  }

  // Public streams
  @override
  Stream<ChatMessage> get messages$ => _dataMessageController.stream;
  @override
  Stream<ConnectionState> get connectionState$ =>
      _connectionStateController.stream;

  // TODO: Media stream getters - uncomment when implementing media features
  // @override
  // Stream<MediaStream> get localStream$ => _localStreamController.stream;
  // @override
  // Stream<MediaStream> get remoteStream$ => _remoteStreamController.stream;

  /// Create connection as caller or callee
  @override
  Future<void> createConnection({required bool isCaller, required String roomId}) async {
    if (isCaller) {
      await _initAsCaller(roomId);
    } else {
      await _initAsCallee(roomId);
    }
  }

  /// Send text message
  @override
  Future<void> sendText(String text) async {
    await _sendMessage(text);
  }

  // TODO: Media methods - uncomment and implement when adding media features
  /*
  /// Prepare media streams with audio and/or video
  @override
  Future<void> prepareMedia({bool audio = true, bool video = false}) async {
    try {
      _logger.i('Preparing media: audio=$audio, video=$video');
      
      // Get user media with specified constraints
      final Map<String, dynamic> constraints = {
        'audio': audio,
        'video': video,
      };
      
      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
      _audioEnabled = audio;
      _videoEnabled = video;
      _mediaInitialized = true;
      
      // Add tracks to peer connection if it exists
      if (_peerConnection != null && _localStream != null) {
        for (var track in _localStream!.getTracks()) {
          await _peerConnection!.addTrack(track, _localStream!);
        }
      }
      
      // Emit local stream
      _localStreamController.add(_localStream!);
      _logger.i('Media prepared successfully');
      
    } catch (e) {
      _logger.e('Failed to prepare media: $e');
      throw Exception('Failed to prepare media: $e');
    }
  }

  /// Stop all media streams and remove tracks
  @override
  Future<void> stopMedia() async {
    try {
      _logger.i('Stopping media streams');
      
      if (_localStream != null) {
        for (var track in _localStream!.getTracks()) {
          track.stop();
          // Remove track from peer connection if it exists
          if (_peerConnection != null) {
            final senders = await _peerConnection!.getSenders();
            for (var sender in senders) {
              if (sender.track == track) {
                await _peerConnection!.removeTrack(sender);
              }
            }
          }
        }
        _localStream = null;
      }
      
      _audioEnabled = false;
      _videoEnabled = false;
      _mediaInitialized = false;
      
      _logger.i('Media stopped successfully');
      
    } catch (e) {
      _logger.e('Failed to stop media: $e');
    }
  }

  /// Toggle audio track on/off
  @override
  Future<void> toggleAudio() async {
    if (_localStream != null) {
      final audioTracks = _localStream!.getAudioTracks();
      for (var track in audioTracks) {
        track.enabled = !track.enabled;
        _audioEnabled = track.enabled;
      }
      _logger.i('Audio toggled: $_audioEnabled');
    }
  }

  /// Toggle video track on/off
  @override
  Future<void> toggleVideo() async {
    if (_localStream != null) {
      final videoTracks = _localStream!.getVideoTracks();
      for (var track in videoTracks) {
        track.enabled = !track.enabled;
        _videoEnabled = track.enabled;
      }
      _logger.i('Video toggled: $_videoEnabled');
    }
  }
  */
  ConnectionState _connectionState = ConnectionState.disconnected;

  bool _isInitialized = false;

  /// Create peer connection with ICE server configuration
  Future<void> _createPeerConnection() async {
    try {
      // Use configuration as specified
      final configuration = {
        'iceServers': [
          {
            'urls': ['stun:stun.l.google.com:19302'],
          },
        ],
      };

      // Create peer connection - this should work with the flutter_webrtc package
      _peerConnection = await createPeerConnection(configuration);
      _setupPeerConnectionListeners();

      _logger.i('Peer connection created successfully');
    } catch (e) {
      _logger.e('Failed to create peer connection: $e');
      _errorController.add('Failed to create peer connection: $e');
      rethrow;
    }
  }

  /// Initialize WebRTC as caller (creates offer)
  Future<void> _initAsCaller(String roomId) async {
    try {
      _logger.i('Initializing WebRTC as caller for room: $roomId');

      _currentRoomId = roomId;
      _isCaller = true;

      await _createPeerConnection();
      await _createDataChannel();

      // Create and set local offer
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      // Store offer in SignalingDataSource and get room ID
      final offerData = _rtcOfferToOfferData(offer);
      _currentRoomId = await _signalingDataSource.createRoom(offerData);

      // Listen for ICE candidates from callee
      _listenToRemoteIceCandidates('callee');

      // Listen for answer from callee
      _listenForAnswer(roomId);

      _isInitialized = true;
      _updateConnectionState(ConnectionState.connecting);

      _logger.i('WebRTC caller initialization completed');
    } catch (e) {
      _logger.e('Failed to initialize as caller: $e');
      _errorController.add('Failed to initialize as caller: $e');
      _updateConnectionState(ConnectionState.failed);
      await _cleanupFailedRoom();
      rethrow;
    }
  }

  /// Initialize WebRTC as callee (receives offer and creates answer)
  Future<void> _initAsCallee(String roomId) async {
    try {
      _logger.i('Initializing WebRTC as callee for room: $roomId');

      _currentRoomId = roomId;
      _isCaller = false;

      await _createPeerConnection();

      // Set up data channel listener for incoming channels
      _peerConnection!.onDataChannel = (channel) {
        _dataChannel = channel;
        _setupDataChannelListeners();
        _logger.i('Data channel received from caller');
      };

      // Get offer from SignalingDataSource
      final offerData = await _signalingDataSource.fetchOffer(roomId);
      final offer = _offerDataToRtcOffer(offerData);

      // Set remote description (offer)
      await _peerConnection!.setRemoteDescription(offer);

      // Create and set local answer
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      // Store answer in SignalingDataSource
      final answerData = _rtcAnswerToAnswerData(answer);
      await _signalingDataSource.saveAnswer(roomId, answerData);

      // Listen for ICE candidates from caller
      _listenToRemoteIceCandidates('caller');

      _isInitialized = true;
      _updateConnectionState(ConnectionState.connecting);

      _logger.i('WebRTC callee initialization completed');
    } catch (e) {
      _logger.e('Failed to initialize as callee: $e');
      _errorController.add('Failed to initialize as callee: $e');
      _updateConnectionState(ConnectionState.failed);
      await _cleanupFailedRoom();
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
      _logger.i('Data channel "chat" created');
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
          _errorController.add('Peer connection failed');
          // Clean up failed room
          _cleanupFailedRoom();
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        case RTCPeerConnectionState.RTCPeerConnectionStateNew:
          _updateConnectionState(ConnectionState.connecting);
          break;
      }
    };

    // ICE candidate generation
    _peerConnection!.onIceCandidate = (candidate) {
      _logger.d('ICE candidate generated: ${candidate.candidate}');
      if (_currentRoomId != null) {
        _sendIceCandidate(candidate);
      }
    };

    // ICE connection state changes
    _peerConnection!.onIceConnectionState = (state) {
      _logger.i('ICE connection state: $state');
      switch (state) {
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
        case RTCIceConnectionState.RTCIceConnectionStateCompleted:
          _handleIceConnected();
          break;
        case RTCIceConnectionState.RTCIceConnectionStateFailed:
          _errorController.add('ICE connection failed');
          break;
        default:
          // Continue listening for other states
          break;
      }
    };

    // TODO: Media track handling - uncomment when implementing media features
    /*
    // Handle incoming media tracks (remote stream)
    _peerConnection!.onTrack = (event) {
      _logger.i('Received remote track: ${event.track.kind}');
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        _remoteStreamController.add(_remoteStream!);
        _logger.i('Remote stream added to controller');
      }
    };
    */
  }

  /// Set up data channel event listeners
  void _setupDataChannelListeners() {
    if (_dataChannel == null) return;

    _dataChannel!.onDataChannelState = (state) {
      _logger.i('Data channel state: $state');
      if (state == RTCDataChannelState.RTCDataChannelOpen) {
        _logger.i('Data channel is now open for messaging');
      }
    };

    _dataChannel!.onMessage = (message) {
      _logger.d('Received message: ${message.text}');
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
  Future<void> _sendMessage(String text) async {
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

      _logger.d('Message sent successfully: $text');
    } catch (e) {
      _logger.e('Failed to send message: $e');
      _errorController.add('Failed to send message: $e');
      rethrow;
    }
  }

  /// Send ICE candidate to SignalingDataSource
  Future<void> _sendIceCandidate(RTCIceCandidate candidate) async {
    if (_currentRoomId == null) return;

    try {
      final type = _isCaller ? 'caller' : 'callee';
      final candidateModel = _rtcCandidateToModel(candidate);
      await _signalingDataSource.addIceCandidate(
        _currentRoomId!,
        type,
        candidateModel,
      );
      _logger.d('ICE candidate sent to SignalingDataSource');
    } catch (e) {
      _logger.e('Failed to send ICE candidate: $e');
      _errorController.add('Failed to send ICE candidate: $e');
    }
  }

  /// Listen to remote ICE candidates from SignalingDataSource
  void _listenToRemoteIceCandidates(String remoteType) {
    if (_currentRoomId == null) return;

    _iceCandidatesSubscription = _signalingDataSource
        .watchIceCandidates(_currentRoomId!, remoteType)
        .listen(
          (candidates) async {
            try {
              for (final candidateModel in candidates) {
                final candidate = _modelToRtcCandidate(candidateModel);
                await _peerConnection!.addCandidate(candidate);
              }
              _logger.d('Remote ICE candidates added: ${candidates.length}');
            } catch (e) {
              _logger.e('Failed to add remote ICE candidates: $e');
            }
          },
          onError: (e) {
            _logger.e('Error listening to ICE candidates: $e');
            _errorController.add('Error listening to ICE candidates: $e');
          },
        );
  }

  /// Handle ICE connection established - implement security cleanup
  Future<void> _handleIceConnected() async {
    if (_isConnected) return; // Already handled
    
    _isConnected = true;
    _logger.i('ICE connection established - initiating security cleanup');
    
    try {
      // Stop listening to ICE candidates
      await _iceCandidatesSubscription?.cancel();
      _iceCandidatesSubscription = null;
      _logger.i('Stopped listening to ICE candidates');
      
      // Mark room as connected to stop further candidate exchanges
      if (_currentRoomId != null) {
        await _signalingDataSource.markRoomConnected(_currentRoomId!);
        _logger.i('Marked room as connected in signaling');
      }
      
      // Clear SDP bodies after a short delay to ensure both peers are connected
      Future.delayed(const Duration(seconds: 2), () async {
        await _clearSdpBodies();
      });
      
    } catch (e) {
      _logger.e('Error during ICE connected cleanup: $e');
    }
  }

  /// Clear SDP offer/answer bodies for security
  Future<void> _clearSdpBodies() async {
    if (_sdpCleared || _currentRoomId == null) return;
    
    try {
      await _signalingDataSource.clearSdpBodies(_currentRoomId!);
      _sdpCleared = true;
      _logger.i('SDP bodies cleared for security');
    } catch (e) {
      _logger.e('Error clearing SDP bodies: $e');
    }
  }

  /// Clean up room data when connection fails
  Future<void> _cleanupFailedRoom() async {
    if (_currentRoomId == null) return;
    
    try {
      await _signalingDataSource.cleanupRoom(_currentRoomId!);
      _logger.i('Cleaned up failed room: $_currentRoomId');
    } catch (e) {
      _logger.e('Error cleaning up failed room: $e');
    }
  }
  void _listenForAnswer(String roomId) {
    if (!_isCaller) return;

    // Watch for answer using SignalingDataSource
    _signalingDataSource.watchAnswer(roomId).listen(
      (answerData) async {
        if (answerData != null) {
          try {
            final answer = _answerDataToRtcAnswer(answerData);
            await _peerConnection!.setRemoteDescription(answer);
            _logger.i('Answer received and set as remote description');
          } catch (e) {
            _logger.e('Error processing answer: $e');
            _errorController.add('Error processing answer: $e');
          }
        }
      },
      onError: (e) {
        _logger.e('Error watching for answer: $e');
        _errorController.add('Error watching for answer: $e');
      },
    );
  }

  /// Add ICE candidate manually
  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    if (_peerConnection == null) {
      throw StateError('Peer connection not initialized');
    }

    try {
      await _peerConnection!.addCandidate(candidate);
      _logger.d('ICE candidate added successfully');
    } catch (e) {
      _logger.e('Failed to add ICE candidate: $e');
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
    } catch (e) {
      _logger.e('Failed to set remote description: $e');
      rethrow;
    }
  }

  /// Get local description
  Future<RTCSessionDescription?> getLocalDescription() async {
    return _peerConnection?.getLocalDescription();
  }

  /// Update connection state and notify listeners
  void _updateConnectionState(ConnectionState newState) {
    if (_connectionState != newState) {
      _connectionState = newState;
      _connectionStateController.add(newState);
      _logger.i('Connection state updated to: $newState');
    }
  }

  /// Get debug information about peer connection
  @override
  String getDebugInfo() {
    if (_peerConnection == null) {
      return 'PeerConnection: null';
    }
    
    return 'PeerConnection - Signaling: ${_peerConnection!.signalingState}, ICE: ${_peerConnection!.iceConnectionState}';
  }

  /// Dispose of all resources
  @override
  Future<void> dispose() async {
    try {
      _logger.i('Disposing WebRTC service');

      _isInitialized = false;
      
      // Clean up failed room if not properly connected
      if (!_isConnected && _currentRoomId != null) {
        await _cleanupFailedRoom();
      }
      
      // Cancel ICE candidates subscription
      await _iceCandidatesSubscription?.cancel();
      _iceCandidatesSubscription = null;

      // Close data channel first
      if (_dataChannel != null) {
        try {
          await _dataChannel!.close();
          _logger.d('Data channel closed');
        } catch (e) {
          _logger.w('Error closing data channel: $e');
        }
        _dataChannel = null;
      }

      // Close peer connection
      if (_peerConnection != null) {
        try {
          await _peerConnection!.close();
          _logger.d('Peer connection closed');
        } catch (e) {
          _logger.w('Error closing peer connection: $e');
        }
        _peerConnection = null;
      }

      // Close streams
      try {
        await _dataMessageController.close();
        await _connectionStateController.close();
        await _errorController.close();
        
        // TODO: Close media stream controllers when implementing media features
        // await _localStreamController.close();
        // await _remoteStreamController.close();
        
        _logger.d('Stream controllers closed');
      } catch (e) {
        _logger.w('Error closing stream controllers: $e');
      }

      // TODO: Cleanup media streams when implementing media features
      /*
      // Stop and cleanup media streams
      if (_localStream != null) {
        for (var track in _localStream!.getTracks()) {
          track.stop();
        }
        _localStream = null;
      }
      if (_remoteStream != null) {
        for (var track in _remoteStream!.getTracks()) {
          track.stop();
        }
        _remoteStream = null;
      }
      _audioEnabled = false;
      _videoEnabled = false;
      _mediaInitialized = false;
      */

      _currentRoomId = null;
      _updateConnectionState(ConnectionState.disconnected);

      _logger.i('WebRTC service disposed successfully');
    } catch (e) {
      _logger.e('Error during disposal: $e');
      // Don't rethrow - disposal should always complete
    }
  }
}
