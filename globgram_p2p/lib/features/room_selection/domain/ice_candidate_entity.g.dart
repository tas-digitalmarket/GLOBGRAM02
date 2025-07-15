// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ice_candidate_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IceCandidateEntityImpl _$$IceCandidateEntityImplFromJson(
  Map<String, dynamic> json,
) => _$IceCandidateEntityImpl(
  candidate: json['candidate'] as String,
  sdpMid: json['sdpMid'] as String,
  sdpMLineIndex: (json['sdpMLineIndex'] as num).toInt(),
);

Map<String, dynamic> _$$IceCandidateEntityImplToJson(
  _$IceCandidateEntityImpl instance,
) => <String, dynamic>{
  'candidate': instance.candidate,
  'sdpMid': instance.sdpMid,
  'sdpMLineIndex': instance.sdpMLineIndex,
};
