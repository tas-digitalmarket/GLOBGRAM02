import 'package:globgram_p2p/features/room_selection/data/models/signaling_models.dart';

/// Abstract data source interface for signaling operations
abstract class SignalingDataSource {
  /// Creates a new room with the given room ID
  Future<void> createRoom(String roomId);

  /// Attempts to join a room. Returns true if successful, false if room is full
  Future<bool> joinRoom(String roomId);

  /// Leaves a room and cleans up resources
  Future<void> leaveRoom(String roomId);

  /// Checks if a room exists
  Future<bool> roomExists(String roomId);

  /// Sends an offer to the specified room
  Future<void> sendOffer(String roomId, OfferData offer);

  /// Listens for offers in the specified room
  Stream<OfferData?> listenForOffer(String roomId);

  /// Sends an answer to the specified room
  Future<void> sendAnswer(String roomId, AnswerData answer);

  /// Listens for answers in the specified room
  Stream<AnswerData?> listenForAnswer(String roomId);

  /// Adds an ICE candidate for the specified room
  Future<void> addIceCandidate(
    String roomId,
    IceCandidateModel candidate,
    bool isFromCaller,
  );

  /// Listens for ICE candidates for the specified room
  Stream<List<IceCandidateModel>> listenForIceCandidates(
    String roomId,
    bool isForCaller,
  );

  /// Clears all data for a room
  Future<void> clearRoom(String roomId);
}
