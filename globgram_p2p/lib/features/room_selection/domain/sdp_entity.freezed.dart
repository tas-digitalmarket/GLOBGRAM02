// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdp_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SdpEntity _$SdpEntityFromJson(Map<String, dynamic> json) {
  return _SdpEntity.fromJson(json);
}

/// @nodoc
mixin _$SdpEntity {
  String get type => throw _privateConstructorUsedError;
  String get sdp => throw _privateConstructorUsedError;

  /// Serializes this SdpEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SdpEntityCopyWith<SdpEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SdpEntityCopyWith<$Res> {
  factory $SdpEntityCopyWith(SdpEntity value, $Res Function(SdpEntity) then) =
      _$SdpEntityCopyWithImpl<$Res, SdpEntity>;
  @useResult
  $Res call({String type, String sdp});
}

/// @nodoc
class _$SdpEntityCopyWithImpl<$Res, $Val extends SdpEntity>
    implements $SdpEntityCopyWith<$Res> {
  _$SdpEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? sdp = null}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            sdp: null == sdp
                ? _value.sdp
                : sdp // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SdpEntityImplCopyWith<$Res>
    implements $SdpEntityCopyWith<$Res> {
  factory _$$SdpEntityImplCopyWith(
    _$SdpEntityImpl value,
    $Res Function(_$SdpEntityImpl) then,
  ) = __$$SdpEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String sdp});
}

/// @nodoc
class __$$SdpEntityImplCopyWithImpl<$Res>
    extends _$SdpEntityCopyWithImpl<$Res, _$SdpEntityImpl>
    implements _$$SdpEntityImplCopyWith<$Res> {
  __$$SdpEntityImplCopyWithImpl(
    _$SdpEntityImpl _value,
    $Res Function(_$SdpEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? sdp = null}) {
    return _then(
      _$SdpEntityImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        sdp: null == sdp
            ? _value.sdp
            : sdp // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SdpEntityImpl implements _SdpEntity {
  const _$SdpEntityImpl({required this.type, required this.sdp});

  factory _$SdpEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SdpEntityImplFromJson(json);

  @override
  final String type;
  @override
  final String sdp;

  @override
  String toString() {
    return 'SdpEntity(type: $type, sdp: $sdp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SdpEntityImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.sdp, sdp) || other.sdp == sdp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, sdp);

  /// Create a copy of SdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SdpEntityImplCopyWith<_$SdpEntityImpl> get copyWith =>
      __$$SdpEntityImplCopyWithImpl<_$SdpEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SdpEntityImplToJson(this);
  }
}

abstract class _SdpEntity implements SdpEntity {
  const factory _SdpEntity({
    required final String type,
    required final String sdp,
  }) = _$SdpEntityImpl;

  factory _SdpEntity.fromJson(Map<String, dynamic> json) =
      _$SdpEntityImpl.fromJson;

  @override
  String get type;
  @override
  String get sdp;

  /// Create a copy of SdpEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SdpEntityImplCopyWith<_$SdpEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
