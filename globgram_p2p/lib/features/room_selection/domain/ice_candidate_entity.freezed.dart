// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ice_candidate_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IceCandidateEntity _$IceCandidateEntityFromJson(Map<String, dynamic> json) {
  return _IceCandidateEntity.fromJson(json);
}

/// @nodoc
mixin _$IceCandidateEntity {
  String get candidate => throw _privateConstructorUsedError;
  String get sdpMid => throw _privateConstructorUsedError;
  int get sdpMLineIndex => throw _privateConstructorUsedError;

  /// Serializes this IceCandidateEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IceCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IceCandidateEntityCopyWith<IceCandidateEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IceCandidateEntityCopyWith<$Res> {
  factory $IceCandidateEntityCopyWith(
    IceCandidateEntity value,
    $Res Function(IceCandidateEntity) then,
  ) = _$IceCandidateEntityCopyWithImpl<$Res, IceCandidateEntity>;
  @useResult
  $Res call({String candidate, String sdpMid, int sdpMLineIndex});
}

/// @nodoc
class _$IceCandidateEntityCopyWithImpl<$Res, $Val extends IceCandidateEntity>
    implements $IceCandidateEntityCopyWith<$Res> {
  _$IceCandidateEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IceCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? candidate = null,
    Object? sdpMid = null,
    Object? sdpMLineIndex = null,
  }) {
    return _then(
      _value.copyWith(
            candidate: null == candidate
                ? _value.candidate
                : candidate // ignore: cast_nullable_to_non_nullable
                      as String,
            sdpMid: null == sdpMid
                ? _value.sdpMid
                : sdpMid // ignore: cast_nullable_to_non_nullable
                      as String,
            sdpMLineIndex: null == sdpMLineIndex
                ? _value.sdpMLineIndex
                : sdpMLineIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IceCandidateEntityImplCopyWith<$Res>
    implements $IceCandidateEntityCopyWith<$Res> {
  factory _$$IceCandidateEntityImplCopyWith(
    _$IceCandidateEntityImpl value,
    $Res Function(_$IceCandidateEntityImpl) then,
  ) = __$$IceCandidateEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String candidate, String sdpMid, int sdpMLineIndex});
}

/// @nodoc
class __$$IceCandidateEntityImplCopyWithImpl<$Res>
    extends _$IceCandidateEntityCopyWithImpl<$Res, _$IceCandidateEntityImpl>
    implements _$$IceCandidateEntityImplCopyWith<$Res> {
  __$$IceCandidateEntityImplCopyWithImpl(
    _$IceCandidateEntityImpl _value,
    $Res Function(_$IceCandidateEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IceCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? candidate = null,
    Object? sdpMid = null,
    Object? sdpMLineIndex = null,
  }) {
    return _then(
      _$IceCandidateEntityImpl(
        candidate: null == candidate
            ? _value.candidate
            : candidate // ignore: cast_nullable_to_non_nullable
                  as String,
        sdpMid: null == sdpMid
            ? _value.sdpMid
            : sdpMid // ignore: cast_nullable_to_non_nullable
                  as String,
        sdpMLineIndex: null == sdpMLineIndex
            ? _value.sdpMLineIndex
            : sdpMLineIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IceCandidateEntityImpl implements _IceCandidateEntity {
  const _$IceCandidateEntityImpl({
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
  });

  factory _$IceCandidateEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$IceCandidateEntityImplFromJson(json);

  @override
  final String candidate;
  @override
  final String sdpMid;
  @override
  final int sdpMLineIndex;

  @override
  String toString() {
    return 'IceCandidateEntity(candidate: $candidate, sdpMid: $sdpMid, sdpMLineIndex: $sdpMLineIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IceCandidateEntityImpl &&
            (identical(other.candidate, candidate) ||
                other.candidate == candidate) &&
            (identical(other.sdpMid, sdpMid) || other.sdpMid == sdpMid) &&
            (identical(other.sdpMLineIndex, sdpMLineIndex) ||
                other.sdpMLineIndex == sdpMLineIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, candidate, sdpMid, sdpMLineIndex);

  /// Create a copy of IceCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IceCandidateEntityImplCopyWith<_$IceCandidateEntityImpl> get copyWith =>
      __$$IceCandidateEntityImplCopyWithImpl<_$IceCandidateEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IceCandidateEntityImplToJson(this);
  }
}

abstract class _IceCandidateEntity implements IceCandidateEntity {
  const factory _IceCandidateEntity({
    required final String candidate,
    required final String sdpMid,
    required final int sdpMLineIndex,
  }) = _$IceCandidateEntityImpl;

  factory _IceCandidateEntity.fromJson(Map<String, dynamic> json) =
      _$IceCandidateEntityImpl.fromJson;

  @override
  String get candidate;
  @override
  String get sdpMid;
  @override
  int get sdpMLineIndex;

  /// Create a copy of IceCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IceCandidateEntityImplCopyWith<_$IceCandidateEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
