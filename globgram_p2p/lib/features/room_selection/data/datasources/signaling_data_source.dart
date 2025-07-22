import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';

/// Abstract data source interface for signaling operations
abstract class SignalingDataSource {
  /// Create a room with an offer and return the room ID
  Future<String> createRoom(OfferData offer);

  /// Save an answer for a specific room
  Future<void> saveAnswer(String roomId, AnswerData answer);

  /// Watch for answer updates in a room
  Stream<AnswerData?> watchAnswer(String roomId);

  /// Fetch the offer for a specific room
  Future<OfferData> fetchOffer(String roomId);

  /// Add an ICE candidate for a specific room and role (caller/callee)
  Future<void> addIceCandidate(
    String roomId,
    String role,
    IceCandidateModel candidate,
  );

  /// Watch ICE candidates for a specific room and role
  Stream<List<IceCandidateModel>> watchIceCandidates(
    String roomId,
    String role,
  );

  /// Check if a room exists
  Future<bool> roomExists(String roomId);

  /// Clear SDP bodies after successful connection (security)
  Future<void> clearSdpBodies(String roomId);

  /// Mark room as connected to stop candidate listening
  Future<void> markRoomConnected(String roomId);

  /// Clean up room data when connection fails
  Future<void> cleanupRoom(String roomId);
}
