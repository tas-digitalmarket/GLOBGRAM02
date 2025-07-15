import 'package:freezed_annotation/freezed_annotation.dart';

part 'ice_candidate_entity.freezed.dart';
part 'ice_candidate_entity.g.dart';

@freezed
class IceCandidateEntity with _$IceCandidateEntity {
  const factory IceCandidateEntity({
    required String candidate,
    required String sdpMid,
    required int sdpMLineIndex,
  }) = _IceCandidateEntity;

  factory IceCandidateEntity.fromJson(Map<String, dynamic> json) =>
      _$IceCandidateEntityFromJson(json);
}
