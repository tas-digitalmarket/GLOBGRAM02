import 'package:globgram_p2p/features/room_selection/domain/room_entity.dart';
import 'package:globgram_p2p/features/room_selection/domain/sdp_entity.dart';
import 'package:globgram_p2p/features/room_selection/domain/ice_candidate_entity.dart';

void main() {
  // Test RoomEntity
  final room = RoomEntity(roomId: 'ROOM123', createdAt: DateTime.now());

  // Test room properties
  assert(room.roomId == 'ROOM123');
  assert(room.createdAt.millisecondsSinceEpoch > 0);

  // Test SdpEntity
  final sdp = SdpEntity(
    type: 'offer',
    sdp: 'v=0\r\no=- 123456789 2 IN IP4 127.0.0.1...',
  );

  // Test SDP Entity creation and serialization
  assert(sdp.type == 'offer');
  assert(sdp.sdp.isNotEmpty);

  // Test IceCandidateEntity
  final iceCandidate = IceCandidateEntity(
    candidate: 'candidate:1234567890 1 udp 2130706431 127.0.0.1 54400 typ host',
    sdpMid: '0',
    sdpMLineIndex: 0,
  );

  // Test ICE candidate properties
  assert(iceCandidate.candidate.isNotEmpty);
  assert(iceCandidate.sdpMid == '0');

  // Test JSON serialization/deserialization
  final roomJson = room.toJson();
  final roomFromJson = RoomEntity.fromJson(roomJson);
  assert(room == roomFromJson, 'Room serialization failed');

  final sdpJson = sdp.toJson();
  final sdpFromJson = SdpEntity.fromJson(sdpJson);
  assert(sdp == sdpFromJson, 'SDP serialization failed');

  final candidateJson = iceCandidate.toJson();
  final candidateFromJson = IceCandidateEntity.fromJson(candidateJson);
  assert(
    iceCandidate == candidateFromJson,
    'ICE Candidate serialization failed',
  );
}
