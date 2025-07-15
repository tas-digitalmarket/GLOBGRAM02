import 'package:freezed_annotation/freezed_annotation.dart';

part 'sdp_entity.freezed.dart';
part 'sdp_entity.g.dart';

@freezed
class SdpEntity with _$SdpEntity {
  const factory SdpEntity({
    required String type,
    required String sdp,
  }) = _SdpEntity;

  factory SdpEntity.fromJson(Map<String, dynamic> json) =>
      _$SdpEntityFromJson(json);
}
