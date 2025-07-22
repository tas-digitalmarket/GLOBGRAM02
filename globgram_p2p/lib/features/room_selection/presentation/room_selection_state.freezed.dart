// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RoomSelectionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() creating,
    required TResult Function(String roomId) waitingAnswer,
    required TResult Function(String roomId) joining,
    required TResult Function(String roomId, bool isCaller) connected,
    required TResult Function(String message) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? creating,
    TResult? Function(String roomId)? waitingAnswer,
    TResult? Function(String roomId)? joining,
    TResult? Function(String roomId, bool isCaller)? connected,
    TResult? Function(String message)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? creating,
    TResult Function(String roomId)? waitingAnswer,
    TResult Function(String roomId)? joining,
    TResult Function(String roomId, bool isCaller)? connected,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomSelectionIdle value) idle,
    required TResult Function(RoomSelectionCreating value) creating,
    required TResult Function(RoomSelectionWaitingAnswer value) waitingAnswer,
    required TResult Function(RoomSelectionJoining value) joining,
    required TResult Function(RoomSelectionConnected value) connected,
    required TResult Function(RoomSelectionFailure value) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomSelectionIdle value)? idle,
    TResult? Function(RoomSelectionCreating value)? creating,
    TResult? Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult? Function(RoomSelectionJoining value)? joining,
    TResult? Function(RoomSelectionConnected value)? connected,
    TResult? Function(RoomSelectionFailure value)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomSelectionIdle value)? idle,
    TResult Function(RoomSelectionCreating value)? creating,
    TResult Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult Function(RoomSelectionJoining value)? joining,
    TResult Function(RoomSelectionConnected value)? connected,
    TResult Function(RoomSelectionFailure value)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomSelectionStateCopyWith<$Res> {
  factory $RoomSelectionStateCopyWith(
    RoomSelectionState value,
    $Res Function(RoomSelectionState) then,
  ) = _$RoomSelectionStateCopyWithImpl<$Res, RoomSelectionState>;
}

/// @nodoc
class _$RoomSelectionStateCopyWithImpl<$Res, $Val extends RoomSelectionState>
    implements $RoomSelectionStateCopyWith<$Res> {
  _$RoomSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RoomSelectionIdleImplCopyWith<$Res> {
  factory _$$RoomSelectionIdleImplCopyWith(
    _$RoomSelectionIdleImpl value,
    $Res Function(_$RoomSelectionIdleImpl) then,
  ) = __$$RoomSelectionIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RoomSelectionIdleImplCopyWithImpl<$Res>
    extends _$RoomSelectionStateCopyWithImpl<$Res, _$RoomSelectionIdleImpl>
    implements _$$RoomSelectionIdleImplCopyWith<$Res> {
  __$$RoomSelectionIdleImplCopyWithImpl(
    _$RoomSelectionIdleImpl _value,
    $Res Function(_$RoomSelectionIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RoomSelectionIdleImpl implements RoomSelectionIdle {
  const _$RoomSelectionIdleImpl();

  @override
  String toString() {
    return 'RoomSelectionState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RoomSelectionIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() creating,
    required TResult Function(String roomId) waitingAnswer,
    required TResult Function(String roomId) joining,
    required TResult Function(String roomId, bool isCaller) connected,
    required TResult Function(String message) failure,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? creating,
    TResult? Function(String roomId)? waitingAnswer,
    TResult? Function(String roomId)? joining,
    TResult? Function(String roomId, bool isCaller)? connected,
    TResult? Function(String message)? failure,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? creating,
    TResult Function(String roomId)? waitingAnswer,
    TResult Function(String roomId)? joining,
    TResult Function(String roomId, bool isCaller)? connected,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomSelectionIdle value) idle,
    required TResult Function(RoomSelectionCreating value) creating,
    required TResult Function(RoomSelectionWaitingAnswer value) waitingAnswer,
    required TResult Function(RoomSelectionJoining value) joining,
    required TResult Function(RoomSelectionConnected value) connected,
    required TResult Function(RoomSelectionFailure value) failure,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomSelectionIdle value)? idle,
    TResult? Function(RoomSelectionCreating value)? creating,
    TResult? Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult? Function(RoomSelectionJoining value)? joining,
    TResult? Function(RoomSelectionConnected value)? connected,
    TResult? Function(RoomSelectionFailure value)? failure,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomSelectionIdle value)? idle,
    TResult Function(RoomSelectionCreating value)? creating,
    TResult Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult Function(RoomSelectionJoining value)? joining,
    TResult Function(RoomSelectionConnected value)? connected,
    TResult Function(RoomSelectionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class RoomSelectionIdle implements RoomSelectionState {
  const factory RoomSelectionIdle() = _$RoomSelectionIdleImpl;
}

/// @nodoc
abstract class _$$RoomSelectionCreatingImplCopyWith<$Res> {
  factory _$$RoomSelectionCreatingImplCopyWith(
    _$RoomSelectionCreatingImpl value,
    $Res Function(_$RoomSelectionCreatingImpl) then,
  ) = __$$RoomSelectionCreatingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RoomSelectionCreatingImplCopyWithImpl<$Res>
    extends _$RoomSelectionStateCopyWithImpl<$Res, _$RoomSelectionCreatingImpl>
    implements _$$RoomSelectionCreatingImplCopyWith<$Res> {
  __$$RoomSelectionCreatingImplCopyWithImpl(
    _$RoomSelectionCreatingImpl _value,
    $Res Function(_$RoomSelectionCreatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RoomSelectionCreatingImpl implements RoomSelectionCreating {
  const _$RoomSelectionCreatingImpl();

  @override
  String toString() {
    return 'RoomSelectionState.creating()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomSelectionCreatingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() creating,
    required TResult Function(String roomId) waitingAnswer,
    required TResult Function(String roomId) joining,
    required TResult Function(String roomId, bool isCaller) connected,
    required TResult Function(String message) failure,
  }) {
    return creating();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? creating,
    TResult? Function(String roomId)? waitingAnswer,
    TResult? Function(String roomId)? joining,
    TResult? Function(String roomId, bool isCaller)? connected,
    TResult? Function(String message)? failure,
  }) {
    return creating?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? creating,
    TResult Function(String roomId)? waitingAnswer,
    TResult Function(String roomId)? joining,
    TResult Function(String roomId, bool isCaller)? connected,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (creating != null) {
      return creating();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomSelectionIdle value) idle,
    required TResult Function(RoomSelectionCreating value) creating,
    required TResult Function(RoomSelectionWaitingAnswer value) waitingAnswer,
    required TResult Function(RoomSelectionJoining value) joining,
    required TResult Function(RoomSelectionConnected value) connected,
    required TResult Function(RoomSelectionFailure value) failure,
  }) {
    return creating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomSelectionIdle value)? idle,
    TResult? Function(RoomSelectionCreating value)? creating,
    TResult? Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult? Function(RoomSelectionJoining value)? joining,
    TResult? Function(RoomSelectionConnected value)? connected,
    TResult? Function(RoomSelectionFailure value)? failure,
  }) {
    return creating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomSelectionIdle value)? idle,
    TResult Function(RoomSelectionCreating value)? creating,
    TResult Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult Function(RoomSelectionJoining value)? joining,
    TResult Function(RoomSelectionConnected value)? connected,
    TResult Function(RoomSelectionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (creating != null) {
      return creating(this);
    }
    return orElse();
  }
}

abstract class RoomSelectionCreating implements RoomSelectionState {
  const factory RoomSelectionCreating() = _$RoomSelectionCreatingImpl;
}

/// @nodoc
abstract class _$$RoomSelectionWaitingAnswerImplCopyWith<$Res> {
  factory _$$RoomSelectionWaitingAnswerImplCopyWith(
    _$RoomSelectionWaitingAnswerImpl value,
    $Res Function(_$RoomSelectionWaitingAnswerImpl) then,
  ) = __$$RoomSelectionWaitingAnswerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$RoomSelectionWaitingAnswerImplCopyWithImpl<$Res>
    extends
        _$RoomSelectionStateCopyWithImpl<$Res, _$RoomSelectionWaitingAnswerImpl>
    implements _$$RoomSelectionWaitingAnswerImplCopyWith<$Res> {
  __$$RoomSelectionWaitingAnswerImplCopyWithImpl(
    _$RoomSelectionWaitingAnswerImpl _value,
    $Res Function(_$RoomSelectionWaitingAnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$RoomSelectionWaitingAnswerImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RoomSelectionWaitingAnswerImpl implements RoomSelectionWaitingAnswer {
  const _$RoomSelectionWaitingAnswerImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'RoomSelectionState.waitingAnswer(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomSelectionWaitingAnswerImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomSelectionWaitingAnswerImplCopyWith<_$RoomSelectionWaitingAnswerImpl>
  get copyWith =>
      __$$RoomSelectionWaitingAnswerImplCopyWithImpl<
        _$RoomSelectionWaitingAnswerImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() creating,
    required TResult Function(String roomId) waitingAnswer,
    required TResult Function(String roomId) joining,
    required TResult Function(String roomId, bool isCaller) connected,
    required TResult Function(String message) failure,
  }) {
    return waitingAnswer(roomId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? creating,
    TResult? Function(String roomId)? waitingAnswer,
    TResult? Function(String roomId)? joining,
    TResult? Function(String roomId, bool isCaller)? connected,
    TResult? Function(String message)? failure,
  }) {
    return waitingAnswer?.call(roomId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? creating,
    TResult Function(String roomId)? waitingAnswer,
    TResult Function(String roomId)? joining,
    TResult Function(String roomId, bool isCaller)? connected,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (waitingAnswer != null) {
      return waitingAnswer(roomId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomSelectionIdle value) idle,
    required TResult Function(RoomSelectionCreating value) creating,
    required TResult Function(RoomSelectionWaitingAnswer value) waitingAnswer,
    required TResult Function(RoomSelectionJoining value) joining,
    required TResult Function(RoomSelectionConnected value) connected,
    required TResult Function(RoomSelectionFailure value) failure,
  }) {
    return waitingAnswer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomSelectionIdle value)? idle,
    TResult? Function(RoomSelectionCreating value)? creating,
    TResult? Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult? Function(RoomSelectionJoining value)? joining,
    TResult? Function(RoomSelectionConnected value)? connected,
    TResult? Function(RoomSelectionFailure value)? failure,
  }) {
    return waitingAnswer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomSelectionIdle value)? idle,
    TResult Function(RoomSelectionCreating value)? creating,
    TResult Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult Function(RoomSelectionJoining value)? joining,
    TResult Function(RoomSelectionConnected value)? connected,
    TResult Function(RoomSelectionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (waitingAnswer != null) {
      return waitingAnswer(this);
    }
    return orElse();
  }
}

abstract class RoomSelectionWaitingAnswer implements RoomSelectionState {
  const factory RoomSelectionWaitingAnswer({required final String roomId}) =
      _$RoomSelectionWaitingAnswerImpl;

  String get roomId;

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomSelectionWaitingAnswerImplCopyWith<_$RoomSelectionWaitingAnswerImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RoomSelectionJoiningImplCopyWith<$Res> {
  factory _$$RoomSelectionJoiningImplCopyWith(
    _$RoomSelectionJoiningImpl value,
    $Res Function(_$RoomSelectionJoiningImpl) then,
  ) = __$$RoomSelectionJoiningImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$RoomSelectionJoiningImplCopyWithImpl<$Res>
    extends _$RoomSelectionStateCopyWithImpl<$Res, _$RoomSelectionJoiningImpl>
    implements _$$RoomSelectionJoiningImplCopyWith<$Res> {
  __$$RoomSelectionJoiningImplCopyWithImpl(
    _$RoomSelectionJoiningImpl _value,
    $Res Function(_$RoomSelectionJoiningImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$RoomSelectionJoiningImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RoomSelectionJoiningImpl implements RoomSelectionJoining {
  const _$RoomSelectionJoiningImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'RoomSelectionState.joining(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomSelectionJoiningImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomSelectionJoiningImplCopyWith<_$RoomSelectionJoiningImpl>
  get copyWith =>
      __$$RoomSelectionJoiningImplCopyWithImpl<_$RoomSelectionJoiningImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() creating,
    required TResult Function(String roomId) waitingAnswer,
    required TResult Function(String roomId) joining,
    required TResult Function(String roomId, bool isCaller) connected,
    required TResult Function(String message) failure,
  }) {
    return joining(roomId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? creating,
    TResult? Function(String roomId)? waitingAnswer,
    TResult? Function(String roomId)? joining,
    TResult? Function(String roomId, bool isCaller)? connected,
    TResult? Function(String message)? failure,
  }) {
    return joining?.call(roomId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? creating,
    TResult Function(String roomId)? waitingAnswer,
    TResult Function(String roomId)? joining,
    TResult Function(String roomId, bool isCaller)? connected,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (joining != null) {
      return joining(roomId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomSelectionIdle value) idle,
    required TResult Function(RoomSelectionCreating value) creating,
    required TResult Function(RoomSelectionWaitingAnswer value) waitingAnswer,
    required TResult Function(RoomSelectionJoining value) joining,
    required TResult Function(RoomSelectionConnected value) connected,
    required TResult Function(RoomSelectionFailure value) failure,
  }) {
    return joining(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomSelectionIdle value)? idle,
    TResult? Function(RoomSelectionCreating value)? creating,
    TResult? Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult? Function(RoomSelectionJoining value)? joining,
    TResult? Function(RoomSelectionConnected value)? connected,
    TResult? Function(RoomSelectionFailure value)? failure,
  }) {
    return joining?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomSelectionIdle value)? idle,
    TResult Function(RoomSelectionCreating value)? creating,
    TResult Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult Function(RoomSelectionJoining value)? joining,
    TResult Function(RoomSelectionConnected value)? connected,
    TResult Function(RoomSelectionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (joining != null) {
      return joining(this);
    }
    return orElse();
  }
}

abstract class RoomSelectionJoining implements RoomSelectionState {
  const factory RoomSelectionJoining({required final String roomId}) =
      _$RoomSelectionJoiningImpl;

  String get roomId;

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomSelectionJoiningImplCopyWith<_$RoomSelectionJoiningImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RoomSelectionConnectedImplCopyWith<$Res> {
  factory _$$RoomSelectionConnectedImplCopyWith(
    _$RoomSelectionConnectedImpl value,
    $Res Function(_$RoomSelectionConnectedImpl) then,
  ) = __$$RoomSelectionConnectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String roomId, bool isCaller});
}

/// @nodoc
class __$$RoomSelectionConnectedImplCopyWithImpl<$Res>
    extends _$RoomSelectionStateCopyWithImpl<$Res, _$RoomSelectionConnectedImpl>
    implements _$$RoomSelectionConnectedImplCopyWith<$Res> {
  __$$RoomSelectionConnectedImplCopyWithImpl(
    _$RoomSelectionConnectedImpl _value,
    $Res Function(_$RoomSelectionConnectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? isCaller = null}) {
    return _then(
      _$RoomSelectionConnectedImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        isCaller: null == isCaller
            ? _value.isCaller
            : isCaller // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RoomSelectionConnectedImpl implements RoomSelectionConnected {
  const _$RoomSelectionConnectedImpl({
    required this.roomId,
    required this.isCaller,
  });

  @override
  final String roomId;
  @override
  final bool isCaller;

  @override
  String toString() {
    return 'RoomSelectionState.connected(roomId: $roomId, isCaller: $isCaller)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomSelectionConnectedImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.isCaller, isCaller) ||
                other.isCaller == isCaller));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, isCaller);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomSelectionConnectedImplCopyWith<_$RoomSelectionConnectedImpl>
  get copyWith =>
      __$$RoomSelectionConnectedImplCopyWithImpl<_$RoomSelectionConnectedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() creating,
    required TResult Function(String roomId) waitingAnswer,
    required TResult Function(String roomId) joining,
    required TResult Function(String roomId, bool isCaller) connected,
    required TResult Function(String message) failure,
  }) {
    return connected(roomId, isCaller);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? creating,
    TResult? Function(String roomId)? waitingAnswer,
    TResult? Function(String roomId)? joining,
    TResult? Function(String roomId, bool isCaller)? connected,
    TResult? Function(String message)? failure,
  }) {
    return connected?.call(roomId, isCaller);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? creating,
    TResult Function(String roomId)? waitingAnswer,
    TResult Function(String roomId)? joining,
    TResult Function(String roomId, bool isCaller)? connected,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(roomId, isCaller);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomSelectionIdle value) idle,
    required TResult Function(RoomSelectionCreating value) creating,
    required TResult Function(RoomSelectionWaitingAnswer value) waitingAnswer,
    required TResult Function(RoomSelectionJoining value) joining,
    required TResult Function(RoomSelectionConnected value) connected,
    required TResult Function(RoomSelectionFailure value) failure,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomSelectionIdle value)? idle,
    TResult? Function(RoomSelectionCreating value)? creating,
    TResult? Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult? Function(RoomSelectionJoining value)? joining,
    TResult? Function(RoomSelectionConnected value)? connected,
    TResult? Function(RoomSelectionFailure value)? failure,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomSelectionIdle value)? idle,
    TResult Function(RoomSelectionCreating value)? creating,
    TResult Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult Function(RoomSelectionJoining value)? joining,
    TResult Function(RoomSelectionConnected value)? connected,
    TResult Function(RoomSelectionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class RoomSelectionConnected implements RoomSelectionState {
  const factory RoomSelectionConnected({
    required final String roomId,
    required final bool isCaller,
  }) = _$RoomSelectionConnectedImpl;

  String get roomId;
  bool get isCaller;

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomSelectionConnectedImplCopyWith<_$RoomSelectionConnectedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RoomSelectionFailureImplCopyWith<$Res> {
  factory _$$RoomSelectionFailureImplCopyWith(
    _$RoomSelectionFailureImpl value,
    $Res Function(_$RoomSelectionFailureImpl) then,
  ) = __$$RoomSelectionFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$RoomSelectionFailureImplCopyWithImpl<$Res>
    extends _$RoomSelectionStateCopyWithImpl<$Res, _$RoomSelectionFailureImpl>
    implements _$$RoomSelectionFailureImplCopyWith<$Res> {
  __$$RoomSelectionFailureImplCopyWithImpl(
    _$RoomSelectionFailureImpl _value,
    $Res Function(_$RoomSelectionFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$RoomSelectionFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RoomSelectionFailureImpl implements RoomSelectionFailure {
  const _$RoomSelectionFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'RoomSelectionState.failure(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomSelectionFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomSelectionFailureImplCopyWith<_$RoomSelectionFailureImpl>
  get copyWith =>
      __$$RoomSelectionFailureImplCopyWithImpl<_$RoomSelectionFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() creating,
    required TResult Function(String roomId) waitingAnswer,
    required TResult Function(String roomId) joining,
    required TResult Function(String roomId, bool isCaller) connected,
    required TResult Function(String message) failure,
  }) {
    return failure(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? creating,
    TResult? Function(String roomId)? waitingAnswer,
    TResult? Function(String roomId)? joining,
    TResult? Function(String roomId, bool isCaller)? connected,
    TResult? Function(String message)? failure,
  }) {
    return failure?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? creating,
    TResult Function(String roomId)? waitingAnswer,
    TResult Function(String roomId)? joining,
    TResult Function(String roomId, bool isCaller)? connected,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomSelectionIdle value) idle,
    required TResult Function(RoomSelectionCreating value) creating,
    required TResult Function(RoomSelectionWaitingAnswer value) waitingAnswer,
    required TResult Function(RoomSelectionJoining value) joining,
    required TResult Function(RoomSelectionConnected value) connected,
    required TResult Function(RoomSelectionFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomSelectionIdle value)? idle,
    TResult? Function(RoomSelectionCreating value)? creating,
    TResult? Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult? Function(RoomSelectionJoining value)? joining,
    TResult? Function(RoomSelectionConnected value)? connected,
    TResult? Function(RoomSelectionFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomSelectionIdle value)? idle,
    TResult Function(RoomSelectionCreating value)? creating,
    TResult Function(RoomSelectionWaitingAnswer value)? waitingAnswer,
    TResult Function(RoomSelectionJoining value)? joining,
    TResult Function(RoomSelectionConnected value)? connected,
    TResult Function(RoomSelectionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class RoomSelectionFailure implements RoomSelectionState {
  const factory RoomSelectionFailure({required final String message}) =
      _$RoomSelectionFailureImpl;

  String get message;

  /// Create a copy of RoomSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomSelectionFailureImplCopyWith<_$RoomSelectionFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}
