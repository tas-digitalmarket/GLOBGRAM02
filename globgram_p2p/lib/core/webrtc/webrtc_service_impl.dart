import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';

/// Real WebRTC service implementation using flutter_webrtc
class WebRTCServiceImpl implements WebRTCService {
  static final Logger _logger = Logger();
  
  final SignalingDataSource _signalingDataSource;
  
  // WebRTC components
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  
  // Stream controllers
  final StreamController<ChatMessage> _messagesController = StreamController<ChatMessage>.broadcast();
  final StreamController<ConnectionState> _connectionStateController = StreamController<ConnectionState>.broadcast();
  final StreamController<MediaStream> _localStreamController = StreamController<MediaStream>.broadcast();
  final StreamController<MediaStream> _remoteStreamController = StreamController<MediaStream>.broadcast();
  
  // Media components
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  
  // Configuration
  static const Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ]
  };
  
  // State tracking
  String? _currentRoomId;
  bool _isCaller = false;
  bool _isSecureCleanupDone = false;
  StreamSubscription<AnswerData?>? _answerSubscription;
  StreamSubscription<List<IceCandidateModel>>? _iceCandidatesSubscription;
  
  // Unique ID generator for messages
  int _messageIdCounter = 0;

  WebRTCServiceImpl(this._signalingDataSource);

  @override
  Stream<ChatMessage> get messages$ => _messagesController.stream;

  @override
  Stream<ConnectionState> get connectionState$ => _connectionStateController.stream;

  @override
  Stream<MediaStream> get localStream$ => _localStreamController.stream;

  @override
  Stream<MediaStream> get remoteStream$ => _remoteStreamController.stream;

  /// Helper method to map RTCPeerConnectionState to our ConnectionState enum
  ConnectionState _mapConnectionState(RTCPeerConnectionState state) {
    switch (state) {
      case RTCPeerConnectionState.RTCPeerConnectionStateNew:
        return ConnectionState.connecting;
      case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        return ConnectionState.connecting;
      case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
        return ConnectionState.connected;
      case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        return ConnectionState.failed;
      case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        return ConnectionState.disconnected;
      case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
        return ConnectionState.disconnected;
    }
  }

  String _generateMessageId() {
    return 'msg_${DateTime.now().millisecondsSinceEpoch}_${_messageIdCounter++}';
  }

  @override
  Future<String> createConnection({
    required String roomId,
    required bool isCaller,
  }) async {
    try {
      _logger.i('Creating WebRTC connection for room: $roomId (isCaller: $isCaller)');
      
      _currentRoomId = roomId;
      _isCaller = isCaller;
      _isSecureCleanupDone = false;
      
      await _createPeerConnection();
      
      if (isCaller) {
        await _handleCallerFlow();
      } else {
        await _handleCalleeFlow();
      }
      
      _logger.i('WebRTC connection setup completed');
      return roomId;
    } catch (error) {
      _logger.e('Failed to create WebRTC connection: $error');
      _connectionStateController.add(ConnectionState.failed);
      rethrow;
    }
  }

  Future<void> _createPeerConnection() async {
    _logger.d('Creating RTCPeerConnection');
    
    _peerConnection = await createPeerConnection(_iceServers);
    
    // Set up connection state monitoring
    _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      _logger.d('Connection state changed: $state');
      final mappedState = _mapConnectionState(state);
      _connectionStateController.add(mappedState);
    };
    
    // Set up ICE connection state monitoring for security cleanup
    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      _logger.d('ICE connection state changed: $state');
      _handleIceConnectionStateChange(state);
    };
    
    // Set up ICE candidate handling
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _logger.d('ICE candidate generated: ${candidate.candidate}');
      _addIceCandidate(candidate);
    };
    
    // Set up remote stream handling for media
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      _logger.d('Remote track received: ${event.track.kind}');
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams.first;
        _remoteStreamController.add(_remoteStream!);
        _logger.d('Remote stream added');
        
        // TODO: Update UI to display remote video stream
        // TODO: Handle multiple remote streams if needed
      }
    };
    
    // Set up data channel for callee (caller creates it explicitly)
    if (!_isCaller) {
      _peerConnection!.onDataChannel = (RTCDataChannel channel) {
        _logger.d('Data channel received: ${channel.label}');
        _setupDataChannel(channel);
      };
    }
  }

  void _handleIceConnectionStateChange(RTCIceConnectionState state) async {
    _logger.d('ICE connection state: $state');
    
    if (!_isSecureCleanupDone && 
        (state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
         state == RTCIceConnectionState.RTCIceConnectionStateCompleted)) {
      _logger.i('ICE connected - performing secure cleanup');
      await _performSecureCleanup();
      _isSecureCleanupDone = true;
    }
  }

  Future<void> _performSecureCleanup() async {
    if (_currentRoomId == null) return;

    try {
      // 1. Mark room as connected with metadata
      await _signalingDataSource.markRoomConnected(_currentRoomId!);
      _logger.d('Room marked as connected');

      // 2. Clear SDP offer/answer bodies for security
      await _signalingDataSource.clearSdpBodies(_currentRoomId!);
      _logger.d('SDP bodies cleared for security');

      // 3. Stop listening to ICE candidates
      await _iceCandidatesSubscription?.cancel();
      _iceCandidatesSubscription = null;
      _logger.d('ICE candidates listening stopped');

    } catch (error) {
      _logger.e('Error during secure cleanup: $error');
    }
  }

  Future<void> _handleCallerFlow() async {
    _logger.d('Starting caller flow');
    
    // Create data channel
    _dataChannel = await _peerConnection!.createDataChannel(
      'chat',
      RTCDataChannelInit()..ordered = true,
    );
    _setupDataChannel(_dataChannel!);
    
    // Create offer
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    
    _logger.d('Offer created and set as local description');
    
    // Create room with offer via signaling data source
    final offerData = OfferData(
      sdp: offer.sdp!,
      type: offer.type!,
      timestamp: DateTime.now(),
    );
    
    _currentRoomId = await _signalingDataSource.createRoom(offerData);
    _logger.d('Room created with ID: $_currentRoomId');
    
    // Listen for answer
    _answerSubscription = _signalingDataSource.watchAnswer(_currentRoomId!).listen(
      (answer) async {
        if (answer != null) {
          _logger.d('Answer received: ${answer.type}');
          await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(answer.sdp, answer.type),
          );
          _logger.d('Answer set as remote description');
        }
      },
      onError: (error) {
        _logger.e('Error listening for answer: $error');
      },
    );
    
    // Listen for ICE candidates from callee
    _listenForIceCandidates('callee');
  }

  Future<void> _handleCalleeFlow() async {
    _logger.d('Starting callee flow');
    
    // Fetch offer from room
    try {
      final offer = await _signalingDataSource.fetchOffer(_currentRoomId!);
      _logger.d('Offer fetched: ${offer.type}');
      
      // Set remote description
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer.sdp, offer.type),
      );
      
      // Create answer
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      
      _logger.d('Answer created and set as local description');
      
      // Save answer
      final answerData = AnswerData(
        sdp: answer.sdp!,
        type: answer.type!,
        timestamp: DateTime.now(),
      );
      
      await _signalingDataSource.saveAnswer(_currentRoomId!, answerData);
      _logger.d('Answer saved to signaling service');
      
    } catch (error) {
      _logger.e('Error in callee flow: $error');
      rethrow;
    }
    
    // Listen for ICE candidates from caller
    _listenForIceCandidates('caller');
  }

  void _setupDataChannel(RTCDataChannel channel) {
    _dataChannel = channel;
    
    channel.onMessage = (RTCDataChannelMessage message) {
      _logger.d('Data channel message received: ${message.text}');
      
      try {
        final chatMessage = ChatMessage(
          id: _generateMessageId(),
          text: message.text,
          timestamp: DateTime.now(),
          sender: ChatSender.peer,
        );
        _messagesController.add(chatMessage);
      } catch (error) {
        _logger.e('Error processing received message: $error');
      }
    };
    
    channel.onDataChannelState = (RTCDataChannelState state) {
      _logger.d('Data channel state: $state');
    };
  }

  void _listenForIceCandidates(String role) {
    _iceCandidatesSubscription = _signalingDataSource.watchIceCandidates(_currentRoomId!, role).listen(
      (candidates) {
        for (final candidate in candidates) {
          _logger.d('Remote ICE candidate received: ${candidate.candidate}');
          _peerConnection!.addCandidate(
            RTCIceCandidate(
              candidate.candidate,
              candidate.sdpMid,
              candidate.sdpMLineIndex,
            ),
          );
        }
      },
      onError: (error) {
        _logger.e('Error listening for ICE candidates: $error');
      },
    );
  }

  Future<void> _addIceCandidate(RTCIceCandidate candidate) async {
    try {
      final role = _isCaller ? 'caller' : 'callee';
      await _signalingDataSource.addIceCandidate(
        _currentRoomId!,
        role,
        IceCandidateModel(
          candidate: candidate.candidate!,
          sdpMid: candidate.sdpMid,
          sdpMLineIndex: candidate.sdpMLineIndex,
          timestamp: DateTime.now(),
        ),
      );
      _logger.d('ICE candidate added to signaling service');
    } catch (error) {
      _logger.e('Failed to add ICE candidate: $error');
    }
  }

  @override
  Future<void> sendText(String text) async {
    if (_dataChannel == null || _dataChannel!.state != RTCDataChannelState.RTCDataChannelOpen) {
      throw Exception('Data channel is not available or not open');
    }
    
    try {
      _logger.d('Sending text message: $text');
      
      await _dataChannel!.send(RTCDataChannelMessage(text));
      
      // Also emit the message locally for the sender
      final chatMessage = ChatMessage(
        id: _generateMessageId(),
        text: text,
        timestamp: DateTime.now(),
        sender: ChatSender.self,
      );
      _messagesController.add(chatMessage);
      
      _logger.d('Message sent successfully');
    } catch (error) {
      _logger.e('Failed to send message: $error');
      rethrow;
    }
  }

  @override
  String getDebugInfo() {
    final buffer = StringBuffer();
    buffer.writeln('=== WebRTC Service Debug Info ===');
    buffer.writeln('Room ID: $_currentRoomId');
    buffer.writeln('Is Caller: $_isCaller');
    buffer.writeln('Secure Cleanup Done: $_isSecureCleanupDone');
    buffer.writeln('Peer Connection State: ${_peerConnection?.connectionState}');
    buffer.writeln('Data Channel State: ${_dataChannel?.state}');
    buffer.writeln('Data Channel Label: ${_dataChannel?.label}');
    
    if (_peerConnection != null) {
      buffer.writeln('ICE Connection State: ${_peerConnection!.iceConnectionState}');
      buffer.writeln('ICE Gathering State: ${_peerConnection!.iceGatheringState}');
      buffer.writeln('Signaling State: ${_peerConnection!.signalingState}');
    }
    
    buffer.writeln('Active Subscriptions:');
    buffer.writeln('  - Answer: ${_answerSubscription != null}');
    buffer.writeln('  - ICE Candidates: ${_iceCandidatesSubscription != null}');
    buffer.writeln('==================================');
    
    return buffer.toString();
  }

  // Media Support Methods
  @override
  Future<void> prepareMedia({bool audio = true, bool video = false}) async {
    try {
      _logger.i('Preparing media - audio: $audio, video: $video');
      
      // Get user media
      final constraints = <String, dynamic>{
        'audio': audio,
        'video': video ? {
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
          'frameRate': {'ideal': 30},
        } : false,
      };
      
      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
      _logger.d('Local media stream obtained');
      
      // Add tracks to peer connection if it exists
      if (_peerConnection != null) {
        for (final track in _localStream!.getTracks()) {
          await _peerConnection!.addTrack(track, _localStream!);
          _logger.d('Added ${track.kind} track to peer connection');
        }
      }
      
      // Emit local stream
      _localStreamController.add(_localStream!);
      
      // TODO: Add UI components for video display
      // TODO: Add controls for audio/video toggle
      // TODO: Implement proper error handling for permissions
      
      _logger.i('Media preparation completed successfully');
    } catch (error) {
      _logger.e('Failed to prepare media: $error');
      // TODO: Add proper error handling and user notification
      rethrow;
    }
  }

  @override
  Future<void> stopMedia() async {
    try {
      _logger.i('Stopping media streams');
      
      // Stop all tracks in local stream
      if (_localStream != null) {
        for (final track in _localStream!.getTracks()) {
          await track.stop();
          _logger.d('Stopped ${track.kind} track');
        }
        _localStream = null;
      }
      
      // TODO: Update UI to hide video components
      // TODO: Notify user that media has been stopped
      
      _logger.i('Media streams stopped successfully');
    } catch (error) {
      _logger.e('Error stopping media: $error');
    }
  }

  @override
  Future<void> toggleAudio() async {
    try {
      if (_localStream != null) {
        final audioTracks = _localStream!.getAudioTracks();
        if (audioTracks.isNotEmpty) {
          final currentlyEnabled = audioTracks.first.enabled;
          audioTracks.first.enabled = !currentlyEnabled;
          _logger.d('Audio toggled: ${!currentlyEnabled}');
          
          // TODO: Update UI to reflect audio mute state
          // TODO: Add visual indication of mute status
        }
      }
    } catch (error) {
      _logger.e('Error toggling audio: $error');
    }
  }

  @override
  Future<void> toggleVideo() async {
    try {
      if (_localStream != null) {
        final videoTracks = _localStream!.getVideoTracks();
        if (videoTracks.isNotEmpty) {
          final currentlyEnabled = videoTracks.first.enabled;
          videoTracks.first.enabled = !currentlyEnabled;
          _logger.d('Video toggled: ${!currentlyEnabled}');
          
          // TODO: Update UI to show/hide video
          // TODO: Add placeholder when video is disabled
        }
      }
    } catch (error) {
      _logger.e('Error toggling video: $error');
    }
  }

  @override
  Future<void> dispose() async {
    _logger.i('Disposing WebRTC service');
    
    try {
      // Cleanup room if not in connected state
      final currentConnectionState = _peerConnection?.connectionState;
      if (_currentRoomId != null && 
          currentConnectionState != RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        _logger.i('Cleaning up room on dispose (not connected)');
        try {
          await _signalingDataSource.cleanupRoom(_currentRoomId!);
        } catch (cleanupError) {
          _logger.e('Error during room cleanup: $cleanupError');
        }
      }

      // Cancel subscriptions
      await _answerSubscription?.cancel();
      await _iceCandidatesSubscription?.cancel();
      
      // Stop media streams
      await stopMedia();
      
      // Close data channel
      _dataChannel?.close();
      
      // Close peer connection
      await _peerConnection?.close();
      
      // Close stream controllers
      await _messagesController.close();
      await _connectionStateController.close();
      await _localStreamController.close();
      await _remoteStreamController.close();
      
      _logger.i('WebRTC service disposed successfully');
    } catch (error) {
      _logger.e('Error during WebRTC service disposal: $error');
    }
  }
}
