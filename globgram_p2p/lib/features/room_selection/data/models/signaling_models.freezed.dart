// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signaling_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OfferData _$OfferDataFromJson(Map<String, dynamic> json) {
  return _OfferData.fromJson(json);
}

/// @nodoc
mixin _$OfferData {
  String get sdp => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this OfferData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OfferData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfferDataCopyWith<OfferData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfferDataCopyWith<$Res> {
  factory $OfferDataCopyWith(OfferData value, $Res Function(OfferData) then) =
      _$OfferDataCopyWithImpl<$Res, OfferData>;
  @useResult
  $Res call({String sdp, String type, DateTime timestamp});
}

/// @nodoc
class _$OfferDataCopyWithImpl<$Res, $Val extends OfferData>
    implements $OfferDataCopyWith<$Res> {
  _$OfferDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfferData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sdp = null,
    Object? type = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            sdp: null == sdp
                ? _value.sdp
                : sdp // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OfferDataImplCopyWith<$Res>
    implements $OfferDataCopyWith<$Res> {
  factory _$$OfferDataImplCopyWith(
    _$OfferDataImpl value,
    $Res Function(_$OfferDataImpl) then,
  ) = __$$OfferDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sdp, String type, DateTime timestamp});
}

/// @nodoc
class __$$OfferDataImplCopyWithImpl<$Res>
    extends _$OfferDataCopyWithImpl<$Res, _$OfferDataImpl>
    implements _$$OfferDataImplCopyWith<$Res> {
  __$$OfferDataImplCopyWithImpl(
    _$OfferDataImpl _value,
    $Res Function(_$OfferDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfferData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sdp = null,
    Object? type = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$OfferDataImpl(
        sdp: null == sdp
            ? _value.sdp
            : sdp // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OfferDataImpl implements _OfferData {
  const _$OfferDataImpl({
    required this.sdp,
    required this.type,
    required this.timestamp,
  });

  factory _$OfferDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfferDataImplFromJson(json);

  @override
  final String sdp;
  @override
  final String type;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'OfferData(sdp: $sdp, type: $type, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfferDataImpl &&
            (identical(other.sdp, sdp) || other.sdp == sdp) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sdp, type, timestamp);

  /// Create a copy of OfferData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfferDataImplCopyWith<_$OfferDataImpl> get copyWith =>
      __$$OfferDataImplCopyWithImpl<_$OfferDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfferDataImplToJson(this);
  }
}

abstract class _OfferData implements OfferData {
  const factory _OfferData({
    required final String sdp,
    required final String type,
    required final DateTime timestamp,
  }) = _$OfferDataImpl;

  factory _OfferData.fromJson(Map<String, dynamic> json) =
      _$OfferDataImpl.fromJson;

  @override
  String get sdp;
  @override
  String get type;
  @override
  DateTime get timestamp;

  /// Create a copy of OfferData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfferDataImplCopyWith<_$OfferDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnswerData _$AnswerDataFromJson(Map<String, dynamic> json) {
  return _AnswerData.fromJson(json);
}

/// @nodoc
mixin _$AnswerData {
  String get sdp => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this AnswerData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnswerData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerDataCopyWith<AnswerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerDataCopyWith<$Res> {
  factory $AnswerDataCopyWith(
    AnswerData value,
    $Res Function(AnswerData) then,
  ) = _$AnswerDataCopyWithImpl<$Res, AnswerData>;
  @useResult
  $Res call({String sdp, String type, DateTime timestamp});
}

/// @nodoc
class _$AnswerDataCopyWithImpl<$Res, $Val extends AnswerData>
    implements $AnswerDataCopyWith<$Res> {
  _$AnswerDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnswerData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sdp = null,
    Object? type = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            sdp: null == sdp
                ? _value.sdp
                : sdp // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnswerDataImplCopyWith<$Res>
    implements $AnswerDataCopyWith<$Res> {
  factory _$$AnswerDataImplCopyWith(
    _$AnswerDataImpl value,
    $Res Function(_$AnswerDataImpl) then,
  ) = __$$AnswerDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sdp, String type, DateTime timestamp});
}

/// @nodoc
class __$$AnswerDataImplCopyWithImpl<$Res>
    extends _$AnswerDataCopyWithImpl<$Res, _$AnswerDataImpl>
    implements _$$AnswerDataImplCopyWith<$Res> {
  __$$AnswerDataImplCopyWithImpl(
    _$AnswerDataImpl _value,
    $Res Function(_$AnswerDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnswerData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sdp = null,
    Object? type = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$AnswerDataImpl(
        sdp: null == sdp
            ? _value.sdp
            : sdp // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerDataImpl implements _AnswerData {
  const _$AnswerDataImpl({
    required this.sdp,
    required this.type,
    required this.timestamp,
  });

  factory _$AnswerDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerDataImplFromJson(json);

  @override
  final String sdp;
  @override
  final String type;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'AnswerData(sdp: $sdp, type: $type, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerDataImpl &&
            (identical(other.sdp, sdp) || other.sdp == sdp) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sdp, type, timestamp);

  /// Create a copy of AnswerData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerDataImplCopyWith<_$AnswerDataImpl> get copyWith =>
      __$$AnswerDataImplCopyWithImpl<_$AnswerDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerDataImplToJson(this);
  }
}

abstract class _AnswerData implements AnswerData {
  const factory _AnswerData({
    required final String sdp,
    required final String type,
    required final DateTime timestamp,
  }) = _$AnswerDataImpl;

  factory _AnswerData.fromJson(Map<String, dynamic> json) =
      _$AnswerDataImpl.fromJson;

  @override
  String get sdp;
  @override
  String get type;
  @override
  DateTime get timestamp;

  /// Create a copy of AnswerData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerDataImplCopyWith<_$AnswerDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IceCandidateModel _$IceCandidateModelFromJson(Map<String, dynamic> json) {
  return _IceCandidateModel.fromJson(json);
}

/// @nodoc
mixin _$IceCandidateModel {
  String get candidate => throw _privateConstructorUsedError;
  String? get sdpMid => throw _privateConstructorUsedError;
  int? get sdpMLineIndex => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this IceCandidateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IceCandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IceCandidateModelCopyWith<IceCandidateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IceCandidateModelCopyWith<$Res> {
  factory $IceCandidateModelCopyWith(
    IceCandidateModel value,
    $Res Function(IceCandidateModel) then,
  ) = _$IceCandidateModelCopyWithImpl<$Res, IceCandidateModel>;
  @useResult
  $Res call({
    String candidate,
    String? sdpMid,
    int? sdpMLineIndex,
    DateTime timestamp,
  });
}

/// @nodoc
class _$IceCandidateModelCopyWithImpl<$Res, $Val extends IceCandidateModel>
    implements $IceCandidateModelCopyWith<$Res> {
  _$IceCandidateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IceCandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? candidate = null,
    Object? sdpMid = freezed,
    Object? sdpMLineIndex = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            candidate: null == candidate
                ? _value.candidate
                : candidate // ignore: cast_nullable_to_non_nullable
                      as String,
            sdpMid: freezed == sdpMid
                ? _value.sdpMid
                : sdpMid // ignore: cast_nullable_to_non_nullable
                      as String?,
            sdpMLineIndex: freezed == sdpMLineIndex
                ? _value.sdpMLineIndex
                : sdpMLineIndex // ignore: cast_nullable_to_non_nullable
                      as int?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IceCandidateModelImplCopyWith<$Res>
    implements $IceCandidateModelCopyWith<$Res> {
  factory _$$IceCandidateModelImplCopyWith(
    _$IceCandidateModelImpl value,
    $Res Function(_$IceCandidateModelImpl) then,
  ) = __$$IceCandidateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String candidate,
    String? sdpMid,
    int? sdpMLineIndex,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$IceCandidateModelImplCopyWithImpl<$Res>
    extends _$IceCandidateModelCopyWithImpl<$Res, _$IceCandidateModelImpl>
    implements _$$IceCandidateModelImplCopyWith<$Res> {
  __$$IceCandidateModelImplCopyWithImpl(
    _$IceCandidateModelImpl _value,
    $Res Function(_$IceCandidateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IceCandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? candidate = null,
    Object? sdpMid = freezed,
    Object? sdpMLineIndex = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _$IceCandidateModelImpl(
        candidate: null == candidate
            ? _value.candidate
            : candidate // ignore: cast_nullable_to_non_nullable
                  as String,
        sdpMid: freezed == sdpMid
            ? _value.sdpMid
            : sdpMid // ignore: cast_nullable_to_non_nullable
                  as String?,
        sdpMLineIndex: freezed == sdpMLineIndex
            ? _value.sdpMLineIndex
            : sdpMLineIndex // ignore: cast_nullable_to_non_nullable
                  as int?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IceCandidateModelImpl implements _IceCandidateModel {
  const _$IceCandidateModelImpl({
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
    required this.timestamp,
  });

  factory _$IceCandidateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IceCandidateModelImplFromJson(json);

  @override
  final String candidate;
  @override
  final String? sdpMid;
  @override
  final int? sdpMLineIndex;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'IceCandidateModel(candidate: $candidate, sdpMid: $sdpMid, sdpMLineIndex: $sdpMLineIndex, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IceCandidateModelImpl &&
            (identical(other.candidate, candidate) ||
                other.candidate == candidate) &&
            (identical(other.sdpMid, sdpMid) || other.sdpMid == sdpMid) &&
            (identical(other.sdpMLineIndex, sdpMLineIndex) ||
                other.sdpMLineIndex == sdpMLineIndex) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, candidate, sdpMid, sdpMLineIndex, timestamp);

  /// Create a copy of IceCandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IceCandidateModelImplCopyWith<_$IceCandidateModelImpl> get copyWith =>
      __$$IceCandidateModelImplCopyWithImpl<_$IceCandidateModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IceCandidateModelImplToJson(this);
  }
}

abstract class _IceCandidateModel implements IceCandidateModel {
  const factory _IceCandidateModel({
    required final String candidate,
    required final String? sdpMid,
    required final int? sdpMLineIndex,
    required final DateTime timestamp,
  }) = _$IceCandidateModelImpl;

  factory _IceCandidateModel.fromJson(Map<String, dynamic> json) =
      _$IceCandidateModelImpl.fromJson;

  @override
  String get candidate;
  @override
  String? get sdpMid;
  @override
  int? get sdpMLineIndex;
  @override
  DateTime get timestamp;

  /// Create a copy of IceCandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IceCandidateModelImplCopyWith<_$IceCandidateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
