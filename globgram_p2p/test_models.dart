import 'package:globgram_p2p/features/room_selection/domain/room_entity.dart';
import 'package:globgram_p2p/features/room_selection/domain/sdp_entity.dart';
import 'package:globgram_p2p/features/room_selection/domain/ice_candidate_entity.dart';

void main() {
  // Test RoomEntity
  final room = RoomEntity(roomId: 'ROOM123', createdAt: DateTime.now());

  print('Room Entity: ${room.toJson()}');

  // Test SdpEntity
  final sdp = SdpEntity(
    type: 'offer',
    sdp: 'v=0\r\no=- 123456789 2 IN IP4 127.0.0.1...',
  );

  print('SDP Entity: ${sdp.toJson()}');

  // Test IceCandidateEntity
  final iceCandidate = IceCandidateEntity(
    candidate: 'candidate:1234567890 1 udp 2130706431 127.0.0.1 54400 typ host',
    sdpMid: '0',
    sdpMLineIndex: 0,
  );

  print('ICE Candidate Entity: ${iceCandidate.toJson()}');

  // Test JSON serialization/deserialization
  final roomJson = room.toJson();
  final roomFromJson = RoomEntity.fromJson(roomJson);
  print('Room serialization test: ${room == roomFromJson}');

  final sdpJson = sdp.toJson();
  final sdpFromJson = SdpEntity.fromJson(sdpJson);
  print('SDP serialization test: ${sdp == sdpFromJson}');

  final candidateJson = iceCandidate.toJson();
  final candidateFromJson = IceCandidateEntity.fromJson(candidateJson);
  print(
    'ICE Candidate serialization test: ${iceCandidate == candidateFromJson}',
  );
}
