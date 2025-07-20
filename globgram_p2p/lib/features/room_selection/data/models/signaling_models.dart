import 'package:freezed_annotation/freezed_annotation.dart';

part 'signaling_models.freezed.dart';
part 'signaling_models.g.dart';

@freezed
class OfferData with _$OfferData {
  const factory OfferData({
    required String sdp,
    required String type,
    required DateTime timestamp,
  }) = _OfferData;

  factory OfferData.fromJson(Map<String, dynamic> json) =>
      _$OfferDataFromJson(json);
}

@freezed
class AnswerData with _$AnswerData {
  const factory AnswerData({
    required String sdp,
    required String type,
    required DateTime timestamp,
  }) = _AnswerData;

  factory AnswerData.fromJson(Map<String, dynamic> json) =>
      _$AnswerDataFromJson(json);
}

@freezed
class IceCandidateModel with _$IceCandidateModel {
  const factory IceCandidateModel({
    required String candidate,
    required String? sdpMid,
    required int? sdpMLineIndex,
    required DateTime timestamp,
  }) = _IceCandidateModel;

  factory IceCandidateModel.fromJson(Map<String, dynamic> json) =>
      _$IceCandidateModelFromJson(json);
}
