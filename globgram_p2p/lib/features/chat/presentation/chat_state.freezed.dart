// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChatState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String roomId, bool isCaller) connecting,
    required TResult Function(
      String roomId,
      bool isCaller,
      List<ChatMessage> messages,
    )
    connected,
    required TResult Function(String message) error,
    required TResult Function() disconnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String roomId, bool isCaller)? connecting,
    TResult? Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult? Function(String message)? error,
    TResult? Function()? disconnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String roomId, bool isCaller)? connecting,
    TResult Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult Function(String message)? error,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStateInitial value) initial,
    required TResult Function(ChatStateConnecting value) connecting,
    required TResult Function(ChatStateConnected value) connected,
    required TResult Function(ChatStateError value) error,
    required TResult Function(ChatStateDisconnected value) disconnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStateInitial value)? initial,
    TResult? Function(ChatStateConnecting value)? connecting,
    TResult? Function(ChatStateConnected value)? connected,
    TResult? Function(ChatStateError value)? error,
    TResult? Function(ChatStateDisconnected value)? disconnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStateInitial value)? initial,
    TResult Function(ChatStateConnecting value)? connecting,
    TResult Function(ChatStateConnected value)? connected,
    TResult Function(ChatStateError value)? error,
    TResult Function(ChatStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ChatStateInitialImplCopyWith<$Res> {
  factory _$$ChatStateInitialImplCopyWith(
    _$ChatStateInitialImpl value,
    $Res Function(_$ChatStateInitialImpl) then,
  ) = __$$ChatStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChatStateInitialImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateInitialImpl>
    implements _$$ChatStateInitialImplCopyWith<$Res> {
  __$$ChatStateInitialImplCopyWithImpl(
    _$ChatStateInitialImpl _value,
    $Res Function(_$ChatStateInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChatStateInitialImpl implements ChatStateInitial {
  const _$ChatStateInitialImpl();

  @override
  String toString() {
    return 'ChatState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChatStateInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String roomId, bool isCaller) connecting,
    required TResult Function(
      String roomId,
      bool isCaller,
      List<ChatMessage> messages,
    )
    connected,
    required TResult Function(String message) error,
    required TResult Function() disconnected,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String roomId, bool isCaller)? connecting,
    TResult? Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult? Function(String message)? error,
    TResult? Function()? disconnected,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String roomId, bool isCaller)? connecting,
    TResult Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult Function(String message)? error,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStateInitial value) initial,
    required TResult Function(ChatStateConnecting value) connecting,
    required TResult Function(ChatStateConnected value) connected,
    required TResult Function(ChatStateError value) error,
    required TResult Function(ChatStateDisconnected value) disconnected,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStateInitial value)? initial,
    TResult? Function(ChatStateConnecting value)? connecting,
    TResult? Function(ChatStateConnected value)? connected,
    TResult? Function(ChatStateError value)? error,
    TResult? Function(ChatStateDisconnected value)? disconnected,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStateInitial value)? initial,
    TResult Function(ChatStateConnecting value)? connecting,
    TResult Function(ChatStateConnected value)? connected,
    TResult Function(ChatStateError value)? error,
    TResult Function(ChatStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ChatStateInitial implements ChatState {
  const factory ChatStateInitial() = _$ChatStateInitialImpl;
}

/// @nodoc
abstract class _$$ChatStateConnectingImplCopyWith<$Res> {
  factory _$$ChatStateConnectingImplCopyWith(
    _$ChatStateConnectingImpl value,
    $Res Function(_$ChatStateConnectingImpl) then,
  ) = __$$ChatStateConnectingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String roomId, bool isCaller});
}

/// @nodoc
class __$$ChatStateConnectingImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateConnectingImpl>
    implements _$$ChatStateConnectingImplCopyWith<$Res> {
  __$$ChatStateConnectingImplCopyWithImpl(
    _$ChatStateConnectingImpl _value,
    $Res Function(_$ChatStateConnectingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? isCaller = null}) {
    return _then(
      _$ChatStateConnectingImpl(
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

class _$ChatStateConnectingImpl implements ChatStateConnecting {
  const _$ChatStateConnectingImpl({
    required this.roomId,
    required this.isCaller,
  });

  @override
  final String roomId;
  @override
  final bool isCaller;

  @override
  String toString() {
    return 'ChatState.connecting(roomId: $roomId, isCaller: $isCaller)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateConnectingImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.isCaller, isCaller) ||
                other.isCaller == isCaller));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, isCaller);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatStateConnectingImplCopyWith<_$ChatStateConnectingImpl> get copyWith =>
      __$$ChatStateConnectingImplCopyWithImpl<_$ChatStateConnectingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String roomId, bool isCaller) connecting,
    required TResult Function(
      String roomId,
      bool isCaller,
      List<ChatMessage> messages,
    )
    connected,
    required TResult Function(String message) error,
    required TResult Function() disconnected,
  }) {
    return connecting(roomId, isCaller);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String roomId, bool isCaller)? connecting,
    TResult? Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult? Function(String message)? error,
    TResult? Function()? disconnected,
  }) {
    return connecting?.call(roomId, isCaller);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String roomId, bool isCaller)? connecting,
    TResult Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult Function(String message)? error,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting(roomId, isCaller);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStateInitial value) initial,
    required TResult Function(ChatStateConnecting value) connecting,
    required TResult Function(ChatStateConnected value) connected,
    required TResult Function(ChatStateError value) error,
    required TResult Function(ChatStateDisconnected value) disconnected,
  }) {
    return connecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStateInitial value)? initial,
    TResult? Function(ChatStateConnecting value)? connecting,
    TResult? Function(ChatStateConnected value)? connected,
    TResult? Function(ChatStateError value)? error,
    TResult? Function(ChatStateDisconnected value)? disconnected,
  }) {
    return connecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStateInitial value)? initial,
    TResult Function(ChatStateConnecting value)? connecting,
    TResult Function(ChatStateConnected value)? connected,
    TResult Function(ChatStateError value)? error,
    TResult Function(ChatStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting(this);
    }
    return orElse();
  }
}

abstract class ChatStateConnecting implements ChatState {
  const factory ChatStateConnecting({
    required final String roomId,
    required final bool isCaller,
  }) = _$ChatStateConnectingImpl;

  String get roomId;
  bool get isCaller;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatStateConnectingImplCopyWith<_$ChatStateConnectingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatStateConnectedImplCopyWith<$Res> {
  factory _$$ChatStateConnectedImplCopyWith(
    _$ChatStateConnectedImpl value,
    $Res Function(_$ChatStateConnectedImpl) then,
  ) = __$$ChatStateConnectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String roomId, bool isCaller, List<ChatMessage> messages});
}

/// @nodoc
class __$$ChatStateConnectedImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateConnectedImpl>
    implements _$$ChatStateConnectedImplCopyWith<$Res> {
  __$$ChatStateConnectedImplCopyWithImpl(
    _$ChatStateConnectedImpl _value,
    $Res Function(_$ChatStateConnectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? isCaller = null,
    Object? messages = null,
  }) {
    return _then(
      _$ChatStateConnectedImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        isCaller: null == isCaller
            ? _value.isCaller
            : isCaller // ignore: cast_nullable_to_non_nullable
                  as bool,
        messages: null == messages
            ? _value._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<ChatMessage>,
      ),
    );
  }
}

/// @nodoc

class _$ChatStateConnectedImpl implements ChatStateConnected {
  const _$ChatStateConnectedImpl({
    required this.roomId,
    required this.isCaller,
    required final List<ChatMessage> messages,
  }) : _messages = messages;

  @override
  final String roomId;
  @override
  final bool isCaller;
  final List<ChatMessage> _messages;
  @override
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ChatState.connected(roomId: $roomId, isCaller: $isCaller, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateConnectedImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.isCaller, isCaller) ||
                other.isCaller == isCaller) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    isCaller,
    const DeepCollectionEquality().hash(_messages),
  );

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatStateConnectedImplCopyWith<_$ChatStateConnectedImpl> get copyWith =>
      __$$ChatStateConnectedImplCopyWithImpl<_$ChatStateConnectedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String roomId, bool isCaller) connecting,
    required TResult Function(
      String roomId,
      bool isCaller,
      List<ChatMessage> messages,
    )
    connected,
    required TResult Function(String message) error,
    required TResult Function() disconnected,
  }) {
    return connected(roomId, isCaller, messages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String roomId, bool isCaller)? connecting,
    TResult? Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult? Function(String message)? error,
    TResult? Function()? disconnected,
  }) {
    return connected?.call(roomId, isCaller, messages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String roomId, bool isCaller)? connecting,
    TResult Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult Function(String message)? error,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(roomId, isCaller, messages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStateInitial value) initial,
    required TResult Function(ChatStateConnecting value) connecting,
    required TResult Function(ChatStateConnected value) connected,
    required TResult Function(ChatStateError value) error,
    required TResult Function(ChatStateDisconnected value) disconnected,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStateInitial value)? initial,
    TResult? Function(ChatStateConnecting value)? connecting,
    TResult? Function(ChatStateConnected value)? connected,
    TResult? Function(ChatStateError value)? error,
    TResult? Function(ChatStateDisconnected value)? disconnected,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStateInitial value)? initial,
    TResult Function(ChatStateConnecting value)? connecting,
    TResult Function(ChatStateConnected value)? connected,
    TResult Function(ChatStateError value)? error,
    TResult Function(ChatStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class ChatStateConnected implements ChatState {
  const factory ChatStateConnected({
    required final String roomId,
    required final bool isCaller,
    required final List<ChatMessage> messages,
  }) = _$ChatStateConnectedImpl;

  String get roomId;
  bool get isCaller;
  List<ChatMessage> get messages;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatStateConnectedImplCopyWith<_$ChatStateConnectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatStateErrorImplCopyWith<$Res> {
  factory _$$ChatStateErrorImplCopyWith(
    _$ChatStateErrorImpl value,
    $Res Function(_$ChatStateErrorImpl) then,
  ) = __$$ChatStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ChatStateErrorImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateErrorImpl>
    implements _$$ChatStateErrorImplCopyWith<$Res> {
  __$$ChatStateErrorImplCopyWithImpl(
    _$ChatStateErrorImpl _value,
    $Res Function(_$ChatStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ChatStateErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChatStateErrorImpl implements ChatStateError {
  const _$ChatStateErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'ChatState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatStateErrorImplCopyWith<_$ChatStateErrorImpl> get copyWith =>
      __$$ChatStateErrorImplCopyWithImpl<_$ChatStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String roomId, bool isCaller) connecting,
    required TResult Function(
      String roomId,
      bool isCaller,
      List<ChatMessage> messages,
    )
    connected,
    required TResult Function(String message) error,
    required TResult Function() disconnected,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String roomId, bool isCaller)? connecting,
    TResult? Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult? Function(String message)? error,
    TResult? Function()? disconnected,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String roomId, bool isCaller)? connecting,
    TResult Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult Function(String message)? error,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStateInitial value) initial,
    required TResult Function(ChatStateConnecting value) connecting,
    required TResult Function(ChatStateConnected value) connected,
    required TResult Function(ChatStateError value) error,
    required TResult Function(ChatStateDisconnected value) disconnected,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStateInitial value)? initial,
    TResult? Function(ChatStateConnecting value)? connecting,
    TResult? Function(ChatStateConnected value)? connected,
    TResult? Function(ChatStateError value)? error,
    TResult? Function(ChatStateDisconnected value)? disconnected,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStateInitial value)? initial,
    TResult Function(ChatStateConnecting value)? connecting,
    TResult Function(ChatStateConnected value)? connected,
    TResult Function(ChatStateError value)? error,
    TResult Function(ChatStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ChatStateError implements ChatState {
  const factory ChatStateError({required final String message}) =
      _$ChatStateErrorImpl;

  String get message;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatStateErrorImplCopyWith<_$ChatStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatStateDisconnectedImplCopyWith<$Res> {
  factory _$$ChatStateDisconnectedImplCopyWith(
    _$ChatStateDisconnectedImpl value,
    $Res Function(_$ChatStateDisconnectedImpl) then,
  ) = __$$ChatStateDisconnectedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChatStateDisconnectedImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateDisconnectedImpl>
    implements _$$ChatStateDisconnectedImplCopyWith<$Res> {
  __$$ChatStateDisconnectedImplCopyWithImpl(
    _$ChatStateDisconnectedImpl _value,
    $Res Function(_$ChatStateDisconnectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChatStateDisconnectedImpl implements ChatStateDisconnected {
  const _$ChatStateDisconnectedImpl();

  @override
  String toString() {
    return 'ChatState.disconnected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateDisconnectedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String roomId, bool isCaller) connecting,
    required TResult Function(
      String roomId,
      bool isCaller,
      List<ChatMessage> messages,
    )
    connected,
    required TResult Function(String message) error,
    required TResult Function() disconnected,
  }) {
    return disconnected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String roomId, bool isCaller)? connecting,
    TResult? Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult? Function(String message)? error,
    TResult? Function()? disconnected,
  }) {
    return disconnected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String roomId, bool isCaller)? connecting,
    TResult Function(String roomId, bool isCaller, List<ChatMessage> messages)?
    connected,
    TResult Function(String message)? error,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStateInitial value) initial,
    required TResult Function(ChatStateConnecting value) connecting,
    required TResult Function(ChatStateConnected value) connected,
    required TResult Function(ChatStateError value) error,
    required TResult Function(ChatStateDisconnected value) disconnected,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStateInitial value)? initial,
    TResult? Function(ChatStateConnecting value)? connecting,
    TResult? Function(ChatStateConnected value)? connected,
    TResult? Function(ChatStateError value)? error,
    TResult? Function(ChatStateDisconnected value)? disconnected,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStateInitial value)? initial,
    TResult Function(ChatStateConnecting value)? connecting,
    TResult Function(ChatStateConnected value)? connected,
    TResult Function(ChatStateError value)? error,
    TResult Function(ChatStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class ChatStateDisconnected implements ChatState {
  const factory ChatStateDisconnected() = _$ChatStateDisconnectedImpl;
}
