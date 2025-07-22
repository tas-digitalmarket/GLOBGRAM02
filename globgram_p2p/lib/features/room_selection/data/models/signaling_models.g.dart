// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signaling_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferDataImpl _$$OfferDataImplFromJson(Map<String, dynamic> json) =>
    _$OfferDataImpl(
      sdp: json['sdp'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$OfferDataImplToJson(_$OfferDataImpl instance) =>
    <String, dynamic>{
      'sdp': instance.sdp,
      'type': instance.type,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$AnswerDataImpl _$$AnswerDataImplFromJson(Map<String, dynamic> json) =>
    _$AnswerDataImpl(
      sdp: json['sdp'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$AnswerDataImplToJson(_$AnswerDataImpl instance) =>
    <String, dynamic>{
      'sdp': instance.sdp,
      'type': instance.type,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$IceCandidateModelImpl _$$IceCandidateModelImplFromJson(
  Map<String, dynamic> json,
) => _$IceCandidateModelImpl(
  candidate: json['candidate'] as String,
  sdpMid: json['sdpMid'] as String?,
  sdpMLineIndex: (json['sdpMLineIndex'] as num?)?.toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$$IceCandidateModelImplToJson(
  _$IceCandidateModelImpl instance,
) => <String, dynamic>{
  'candidate': instance.candidate,
  'sdpMid': instance.sdpMid,
  'sdpMLineIndex': instance.sdpMLineIndex,
  'timestamp': instance.timestamp.toIso8601String(),
};
