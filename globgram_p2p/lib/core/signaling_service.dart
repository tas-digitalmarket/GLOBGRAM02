import 'dart:math';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:globgram_p2p/core/app_config.dart';
import 'package:globgram_p2p/core/service_locator.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source_firestore.dart';

/// Abstraction layer for signaling operations
/// Routes to either new SignalingDataSource or legacy RoomRemoteDataSourceFirestore
/// based on feature flag configuration
class SignalingService {
  final SignalingDataSource? _signalingDataSource;
  final RoomRemoteDataSourceFirestore? _legacyDataSource;
  final Random _random = Random();

  SignalingService._({
    SignalingDataSource? signalingDataSource,
    RoomRemoteDataSourceFirestore? legacyDataSource,
  })  : _signalingDataSource = signalingDataSource,
        _legacyDataSource = legacyDataSource;

  /// Factory constructor that chooses implementation based on feature flag
  factory SignalingService() {
    if (AppConfig.useFirestoreSignaling) {
      return SignalingService._(
        signalingDataSource: getIt<SignalingDataSource>(),
      );
    } else {
      return SignalingService._(
        legacyDataSource: getIt<RoomRemoteDataSourceFirestore>(),
      );
    }
  }

  /// Create room and return room ID
  Future<String> createRoom(RTCSessionDescription offer) async {
    if (_signalingDataSource != null) {
      // New signaling approach - will implement when freezed models are ready
      throw UnimplementedError(
        'New signaling not yet implemented. Set AppConfig.useFirestoreSignaling = false',
      );
    } else {
      // Legacy approach - generate room ID and store offer
      final roomId = _generateLegacyRoomId();
      await _legacyDataSource!.setOffer(roomId, offer);
      return roomId;
    }
  }

  /// Save answer for room
  Future<void> saveAnswer(String roomId, RTCSessionDescription answer) async {
    if (_signalingDataSource != null) {
      // New signaling approach - will implement when freezed models are ready
      throw UnimplementedError(
        'New signaling not yet implemented. Set AppConfig.useFirestoreSignaling = false',
      );
    } else {
      // Legacy approach
      await _legacyDataSource!.setAnswer(roomId, answer);
    }
  }

  /// Get offer for room
  Future<RTCSessionDescription> getOffer(String roomId) async {
    if (_signalingDataSource != null) {
      // New signaling approach - will implement when freezed models are ready
      throw UnimplementedError(
        'New signaling not yet implemented. Set AppConfig.useFirestoreSignaling = false',
      );
    } else {
      // Legacy approach
      final roomData = await _legacyDataSource!.getRoomData(roomId);
      if (roomData == null || roomData['offer'] == null) {
        throw Exception('No offer found for room: $roomId');
      }
      final offerData = roomData['offer'] as Map<String, dynamic>;
      return RTCSessionDescription(offerData['sdp'], offerData['type']);
    }
  }

  /// Watch for answer
  Stream<RTCSessionDescription?> watchAnswer(String roomId) {
    if (_signalingDataSource != null) {
      // New signaling approach - will implement when freezed models are ready
      throw UnimplementedError(
        'New signaling not yet implemented. Set AppConfig.useFirestoreSignaling = false',
      );
    } else {
      // Legacy approach - would need to implement polling or stream
      throw UnimplementedError(
        'Legacy answer watching not implemented. Enable useFirestoreSignaling.',
      );
    }
  }

  /// Add ICE candidate
  Future<void> addIceCandidate(
    String roomId,
    String role,
    RTCIceCandidate candidate,
  ) async {
    if (_signalingDataSource != null) {
      // New signaling approach - will implement when freezed models are ready
      throw UnimplementedError(
        'New signaling not yet implemented. Set AppConfig.useFirestoreSignaling = false',
      );
    } else {
      // Legacy approach
      await _legacyDataSource!.addIceCandidate(roomId, role, candidate);
    }
  }

  /// Watch ICE candidates
  Stream<List<RTCIceCandidate>> watchIceCandidates(
    String roomId,
    String role,
  ) {
    if (_signalingDataSource != null) {
      // New signaling approach - will implement when freezed models are ready
      throw UnimplementedError(
        'New signaling not yet implemented. Set AppConfig.useFirestoreSignaling = false',
      );
    } else {
      // Legacy approach - convert single stream to list stream
      return _legacyDataSource!.listenIceCandidates(roomId, role).map((candidate) => [candidate]);
    }
  }

  /// Check if room exists
  Future<bool> roomExists(String roomId) async {
    if (_signalingDataSource != null) {
      // New signaling approach - will implement when freezed models are ready
      throw UnimplementedError(
        'New signaling not yet implemented. Set AppConfig.useFirestoreSignaling = false',
      );
    } else {
      // Legacy approach
      final roomData = await _legacyDataSource!.getRoomData(roomId);
      return roomData != null;
    }
  }

  /// Generate room ID for legacy approach
  String _generateLegacyRoomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(8, (index) => chars[_random.nextInt(chars.length)]).join();
  }
}
