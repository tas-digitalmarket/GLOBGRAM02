// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_selection_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RoomSelectionEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() createRequested,
    required TResult Function(String roomId) joinRequested,
    required TResult Function() clearRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? createRequested,
    TResult? Function(String roomId)? joinRequested,
    TResult? Function()? clearRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? createRequested,
    TResult Function(String roomId)? joinRequested,
    TResult Function()? clearRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateRequested value) createRequested,
    required TResult Function(JoinRequested value) joinRequested,
    required TResult Function(ClearRequested value) clearRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateRequested value)? createRequested,
    TResult? Function(JoinRequested value)? joinRequested,
    TResult? Function(ClearRequested value)? clearRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateRequested value)? createRequested,
    TResult Function(JoinRequested value)? joinRequested,
    TResult Function(ClearRequested value)? clearRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomSelectionEventCopyWith<$Res> {
  factory $RoomSelectionEventCopyWith(
    RoomSelectionEvent value,
    $Res Function(RoomSelectionEvent) then,
  ) = _$RoomSelectionEventCopyWithImpl<$Res, RoomSelectionEvent>;
}

/// @nodoc
class _$RoomSelectionEventCopyWithImpl<$Res, $Val extends RoomSelectionEvent>
    implements $RoomSelectionEventCopyWith<$Res> {
  _$RoomSelectionEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomSelectionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CreateRequestedImplCopyWith<$Res> {
  factory _$$CreateRequestedImplCopyWith(
    _$CreateRequestedImpl value,
    $Res Function(_$CreateRequestedImpl) then,
  ) = __$$CreateRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CreateRequestedImplCopyWithImpl<$Res>
    extends _$RoomSelectionEventCopyWithImpl<$Res, _$CreateRequestedImpl>
    implements _$$CreateRequestedImplCopyWith<$Res> {
  __$$CreateRequestedImplCopyWithImpl(
    _$CreateRequestedImpl _value,
    $Res Function(_$CreateRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CreateRequestedImpl implements CreateRequested {
  const _$CreateRequestedImpl();

  @override
  String toString() {
    return 'RoomSelectionEvent.createRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CreateRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() createRequested,
    required TResult Function(String roomId) joinRequested,
    required TResult Function() clearRequested,
  }) {
    return createRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? createRequested,
    TResult? Function(String roomId)? joinRequested,
    TResult? Function()? clearRequested,
  }) {
    return createRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? createRequested,
    TResult Function(String roomId)? joinRequested,
    TResult Function()? clearRequested,
    required TResult orElse(),
  }) {
    if (createRequested != null) {
      return createRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateRequested value) createRequested,
    required TResult Function(JoinRequested value) joinRequested,
    required TResult Function(ClearRequested value) clearRequested,
  }) {
    return createRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateRequested value)? createRequested,
    TResult? Function(JoinRequested value)? joinRequested,
    TResult? Function(ClearRequested value)? clearRequested,
  }) {
    return createRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateRequested value)? createRequested,
    TResult Function(JoinRequested value)? joinRequested,
    TResult Function(ClearRequested value)? clearRequested,
    required TResult orElse(),
  }) {
    if (createRequested != null) {
      return createRequested(this);
    }
    return orElse();
  }
}

abstract class CreateRequested implements RoomSelectionEvent {
  const factory CreateRequested() = _$CreateRequestedImpl;
}

/// @nodoc
abstract class _$$JoinRequestedImplCopyWith<$Res> {
  factory _$$JoinRequestedImplCopyWith(
    _$JoinRequestedImpl value,
    $Res Function(_$JoinRequestedImpl) then,
  ) = __$$JoinRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$JoinRequestedImplCopyWithImpl<$Res>
    extends _$RoomSelectionEventCopyWithImpl<$Res, _$JoinRequestedImpl>
    implements _$$JoinRequestedImplCopyWith<$Res> {
  __$$JoinRequestedImplCopyWithImpl(
    _$JoinRequestedImpl _value,
    $Res Function(_$JoinRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$JoinRequestedImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JoinRequestedImpl implements JoinRequested {
  const _$JoinRequestedImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'RoomSelectionEvent.joinRequested(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinRequestedImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of RoomSelectionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinRequestedImplCopyWith<_$JoinRequestedImpl> get copyWith =>
      __$$JoinRequestedImplCopyWithImpl<_$JoinRequestedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() createRequested,
    required TResult Function(String roomId) joinRequested,
    required TResult Function() clearRequested,
  }) {
    return joinRequested(roomId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? createRequested,
    TResult? Function(String roomId)? joinRequested,
    TResult? Function()? clearRequested,
  }) {
    return joinRequested?.call(roomId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? createRequested,
    TResult Function(String roomId)? joinRequested,
    TResult Function()? clearRequested,
    required TResult orElse(),
  }) {
    if (joinRequested != null) {
      return joinRequested(roomId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateRequested value) createRequested,
    required TResult Function(JoinRequested value) joinRequested,
    required TResult Function(ClearRequested value) clearRequested,
  }) {
    return joinRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateRequested value)? createRequested,
    TResult? Function(JoinRequested value)? joinRequested,
    TResult? Function(ClearRequested value)? clearRequested,
  }) {
    return joinRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateRequested value)? createRequested,
    TResult Function(JoinRequested value)? joinRequested,
    TResult Function(ClearRequested value)? clearRequested,
    required TResult orElse(),
  }) {
    if (joinRequested != null) {
      return joinRequested(this);
    }
    return orElse();
  }
}

abstract class JoinRequested implements RoomSelectionEvent {
  const factory JoinRequested({required final String roomId}) =
      _$JoinRequestedImpl;

  String get roomId;

  /// Create a copy of RoomSelectionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinRequestedImplCopyWith<_$JoinRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearRequestedImplCopyWith<$Res> {
  factory _$$ClearRequestedImplCopyWith(
    _$ClearRequestedImpl value,
    $Res Function(_$ClearRequestedImpl) then,
  ) = __$$ClearRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearRequestedImplCopyWithImpl<$Res>
    extends _$RoomSelectionEventCopyWithImpl<$Res, _$ClearRequestedImpl>
    implements _$$ClearRequestedImplCopyWith<$Res> {
  __$$ClearRequestedImplCopyWithImpl(
    _$ClearRequestedImpl _value,
    $Res Function(_$ClearRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearRequestedImpl implements ClearRequested {
  const _$ClearRequestedImpl();

  @override
  String toString() {
    return 'RoomSelectionEvent.clearRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() createRequested,
    required TResult Function(String roomId) joinRequested,
    required TResult Function() clearRequested,
  }) {
    return clearRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? createRequested,
    TResult? Function(String roomId)? joinRequested,
    TResult? Function()? clearRequested,
  }) {
    return clearRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? createRequested,
    TResult Function(String roomId)? joinRequested,
    TResult Function()? clearRequested,
    required TResult orElse(),
  }) {
    if (clearRequested != null) {
      return clearRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateRequested value) createRequested,
    required TResult Function(JoinRequested value) joinRequested,
    required TResult Function(ClearRequested value) clearRequested,
  }) {
    return clearRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateRequested value)? createRequested,
    TResult? Function(JoinRequested value)? joinRequested,
    TResult? Function(ClearRequested value)? clearRequested,
  }) {
    return clearRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateRequested value)? createRequested,
    TResult Function(JoinRequested value)? joinRequested,
    TResult Function(ClearRequested value)? clearRequested,
    required TResult orElse(),
  }) {
    if (clearRequested != null) {
      return clearRequested(this);
    }
    return orElse();
  }
}

abstract class ClearRequested implements RoomSelectionEvent {
  const factory ClearRequested() = _$ClearRequestedImpl;
}
