import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:globgram_p2p/core/service_locator.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';

/// Service layer for signaling operations using SignalingDataSource abstraction
class SignalingService {
  final SignalingDataSource _signalingDataSource;

  SignalingService._(this._signalingDataSource);

  /// Factory constructor that gets SignalingDataSource from service locator
  factory SignalingService() {
    return SignalingService._(getIt<SignalingDataSource>());
  }

  /// Create room and return room ID
  Future<String> createRoom(RTCSessionDescription offer) async {
    final offerData = OfferData(
      sdp: offer.sdp!,
      type: offer.type!,
      timestamp: DateTime.now(),
    );
    return await _signalingDataSource.createRoom(offerData);
  }

  /// Save answer for room
  Future<void> saveAnswer(String roomId, RTCSessionDescription answer) async {
    final answerData = AnswerData(
      sdp: answer.sdp!,
      type: answer.type!,
      timestamp: DateTime.now(),
    );
    await _signalingDataSource.saveAnswer(roomId, answerData);
  }

  /// Get offer for room
  Future<RTCSessionDescription> getOffer(String roomId) async {
    final offerData = await _signalingDataSource.fetchOffer(roomId);
    return RTCSessionDescription(offerData.sdp, offerData.type);
  }

  /// Watch for answer
  Stream<RTCSessionDescription?> watchAnswer(String roomId) {
    return _signalingDataSource.watchAnswer(roomId).map((answerData) {
      if (answerData == null) return null;
      return RTCSessionDescription(answerData.sdp, answerData.type);
    });
  }

  /// Add ICE candidate
  Future<void> addIceCandidate(
    String roomId,
    String role,
    RTCIceCandidate candidate,
  ) async {
    final candidateModel = IceCandidateModel(
      candidate: candidate.candidate!,
      sdpMid: candidate.sdpMid!,
      sdpMLineIndex: candidate.sdpMLineIndex!,
      timestamp: DateTime.now(),
    );
    await _signalingDataSource.addIceCandidate(roomId, role, candidateModel);
  }

  /// Watch ICE candidates
  Stream<List<RTCIceCandidate>> watchIceCandidates(
    String roomId,
    String role,
  ) {
    return _signalingDataSource.watchIceCandidates(roomId, role).map((candidates) {
      return candidates.map((candidateModel) {
        return RTCIceCandidate(
          candidateModel.candidate,
          candidateModel.sdpMid,
          candidateModel.sdpMLineIndex,
        );
      }).toList();
    });
  }

  /// Check if room exists
  Future<bool> roomExists(String roomId) async {
    return await _signalingDataSource.roomExists(roomId);
  }
}
