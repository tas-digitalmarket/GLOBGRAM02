// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChatEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, bool isCaller)
    initializeConnection,
    required TResult Function(String text) sendMessage,
    required TResult Function(dynamic message) messageReceived,
    required TResult Function(dynamic connectionState) connectionStateChanged,
    required TResult Function(String error) errorOccurred,
    required TResult Function() dispose,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, bool isCaller)? initializeConnection,
    TResult? Function(String text)? sendMessage,
    TResult? Function(dynamic message)? messageReceived,
    TResult? Function(dynamic connectionState)? connectionStateChanged,
    TResult? Function(String error)? errorOccurred,
    TResult? Function()? dispose,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, bool isCaller)? initializeConnection,
    TResult Function(String text)? sendMessage,
    TResult Function(dynamic message)? messageReceived,
    TResult Function(dynamic connectionState)? connectionStateChanged,
    TResult Function(String error)? errorOccurred,
    TResult Function()? dispose,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitializeConnection value)
    initializeConnection,
    required TResult Function(ChatSendMessage value) sendMessage,
    required TResult Function(ChatMessageReceived value) messageReceived,
    required TResult Function(ChatConnectionStateChanged value)
    connectionStateChanged,
    required TResult Function(ChatErrorOccurred value) errorOccurred,
    required TResult Function(ChatDispose value) dispose,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitializeConnection value)? initializeConnection,
    TResult? Function(ChatSendMessage value)? sendMessage,
    TResult? Function(ChatMessageReceived value)? messageReceived,
    TResult? Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult? Function(ChatErrorOccurred value)? errorOccurred,
    TResult? Function(ChatDispose value)? dispose,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitializeConnection value)? initializeConnection,
    TResult Function(ChatSendMessage value)? sendMessage,
    TResult Function(ChatMessageReceived value)? messageReceived,
    TResult Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult Function(ChatErrorOccurred value)? errorOccurred,
    TResult Function(ChatDispose value)? dispose,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatEventCopyWith<$Res> {
  factory $ChatEventCopyWith(ChatEvent value, $Res Function(ChatEvent) then) =
      _$ChatEventCopyWithImpl<$Res, ChatEvent>;
}

/// @nodoc
class _$ChatEventCopyWithImpl<$Res, $Val extends ChatEvent>
    implements $ChatEventCopyWith<$Res> {
  _$ChatEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ChatInitializeConnectionImplCopyWith<$Res> {
  factory _$$ChatInitializeConnectionImplCopyWith(
    _$ChatInitializeConnectionImpl value,
    $Res Function(_$ChatInitializeConnectionImpl) then,
  ) = __$$ChatInitializeConnectionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String roomId, bool isCaller});
}

/// @nodoc
class __$$ChatInitializeConnectionImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatInitializeConnectionImpl>
    implements _$$ChatInitializeConnectionImplCopyWith<$Res> {
  __$$ChatInitializeConnectionImplCopyWithImpl(
    _$ChatInitializeConnectionImpl _value,
    $Res Function(_$ChatInitializeConnectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? isCaller = null}) {
    return _then(
      _$ChatInitializeConnectionImpl(
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

class _$ChatInitializeConnectionImpl implements ChatInitializeConnection {
  const _$ChatInitializeConnectionImpl({
    required this.roomId,
    required this.isCaller,
  });

  @override
  final String roomId;
  @override
  final bool isCaller;

  @override
  String toString() {
    return 'ChatEvent.initializeConnection(roomId: $roomId, isCaller: $isCaller)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatInitializeConnectionImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.isCaller, isCaller) ||
                other.isCaller == isCaller));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, isCaller);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatInitializeConnectionImplCopyWith<_$ChatInitializeConnectionImpl>
  get copyWith =>
      __$$ChatInitializeConnectionImplCopyWithImpl<
        _$ChatInitializeConnectionImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, bool isCaller)
    initializeConnection,
    required TResult Function(String text) sendMessage,
    required TResult Function(dynamic message) messageReceived,
    required TResult Function(dynamic connectionState) connectionStateChanged,
    required TResult Function(String error) errorOccurred,
    required TResult Function() dispose,
  }) {
    return initializeConnection(roomId, isCaller);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, bool isCaller)? initializeConnection,
    TResult? Function(String text)? sendMessage,
    TResult? Function(dynamic message)? messageReceived,
    TResult? Function(dynamic connectionState)? connectionStateChanged,
    TResult? Function(String error)? errorOccurred,
    TResult? Function()? dispose,
  }) {
    return initializeConnection?.call(roomId, isCaller);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, bool isCaller)? initializeConnection,
    TResult Function(String text)? sendMessage,
    TResult Function(dynamic message)? messageReceived,
    TResult Function(dynamic connectionState)? connectionStateChanged,
    TResult Function(String error)? errorOccurred,
    TResult Function()? dispose,
    required TResult orElse(),
  }) {
    if (initializeConnection != null) {
      return initializeConnection(roomId, isCaller);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitializeConnection value)
    initializeConnection,
    required TResult Function(ChatSendMessage value) sendMessage,
    required TResult Function(ChatMessageReceived value) messageReceived,
    required TResult Function(ChatConnectionStateChanged value)
    connectionStateChanged,
    required TResult Function(ChatErrorOccurred value) errorOccurred,
    required TResult Function(ChatDispose value) dispose,
  }) {
    return initializeConnection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitializeConnection value)? initializeConnection,
    TResult? Function(ChatSendMessage value)? sendMessage,
    TResult? Function(ChatMessageReceived value)? messageReceived,
    TResult? Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult? Function(ChatErrorOccurred value)? errorOccurred,
    TResult? Function(ChatDispose value)? dispose,
  }) {
    return initializeConnection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitializeConnection value)? initializeConnection,
    TResult Function(ChatSendMessage value)? sendMessage,
    TResult Function(ChatMessageReceived value)? messageReceived,
    TResult Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult Function(ChatErrorOccurred value)? errorOccurred,
    TResult Function(ChatDispose value)? dispose,
    required TResult orElse(),
  }) {
    if (initializeConnection != null) {
      return initializeConnection(this);
    }
    return orElse();
  }
}

abstract class ChatInitializeConnection implements ChatEvent {
  const factory ChatInitializeConnection({
    required final String roomId,
    required final bool isCaller,
  }) = _$ChatInitializeConnectionImpl;

  String get roomId;
  bool get isCaller;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatInitializeConnectionImplCopyWith<_$ChatInitializeConnectionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatSendMessageImplCopyWith<$Res> {
  factory _$$ChatSendMessageImplCopyWith(
    _$ChatSendMessageImpl value,
    $Res Function(_$ChatSendMessageImpl) then,
  ) = __$$ChatSendMessageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$$ChatSendMessageImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatSendMessageImpl>
    implements _$$ChatSendMessageImplCopyWith<$Res> {
  __$$ChatSendMessageImplCopyWithImpl(
    _$ChatSendMessageImpl _value,
    $Res Function(_$ChatSendMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null}) {
    return _then(
      _$ChatSendMessageImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChatSendMessageImpl implements ChatSendMessage {
  const _$ChatSendMessageImpl({required this.text});

  @override
  final String text;

  @override
  String toString() {
    return 'ChatEvent.sendMessage(text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSendMessageImpl &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSendMessageImplCopyWith<_$ChatSendMessageImpl> get copyWith =>
      __$$ChatSendMessageImplCopyWithImpl<_$ChatSendMessageImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, bool isCaller)
    initializeConnection,
    required TResult Function(String text) sendMessage,
    required TResult Function(dynamic message) messageReceived,
    required TResult Function(dynamic connectionState) connectionStateChanged,
    required TResult Function(String error) errorOccurred,
    required TResult Function() dispose,
  }) {
    return sendMessage(text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, bool isCaller)? initializeConnection,
    TResult? Function(String text)? sendMessage,
    TResult? Function(dynamic message)? messageReceived,
    TResult? Function(dynamic connectionState)? connectionStateChanged,
    TResult? Function(String error)? errorOccurred,
    TResult? Function()? dispose,
  }) {
    return sendMessage?.call(text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, bool isCaller)? initializeConnection,
    TResult Function(String text)? sendMessage,
    TResult Function(dynamic message)? messageReceived,
    TResult Function(dynamic connectionState)? connectionStateChanged,
    TResult Function(String error)? errorOccurred,
    TResult Function()? dispose,
    required TResult orElse(),
  }) {
    if (sendMessage != null) {
      return sendMessage(text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitializeConnection value)
    initializeConnection,
    required TResult Function(ChatSendMessage value) sendMessage,
    required TResult Function(ChatMessageReceived value) messageReceived,
    required TResult Function(ChatConnectionStateChanged value)
    connectionStateChanged,
    required TResult Function(ChatErrorOccurred value) errorOccurred,
    required TResult Function(ChatDispose value) dispose,
  }) {
    return sendMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitializeConnection value)? initializeConnection,
    TResult? Function(ChatSendMessage value)? sendMessage,
    TResult? Function(ChatMessageReceived value)? messageReceived,
    TResult? Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult? Function(ChatErrorOccurred value)? errorOccurred,
    TResult? Function(ChatDispose value)? dispose,
  }) {
    return sendMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitializeConnection value)? initializeConnection,
    TResult Function(ChatSendMessage value)? sendMessage,
    TResult Function(ChatMessageReceived value)? messageReceived,
    TResult Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult Function(ChatErrorOccurred value)? errorOccurred,
    TResult Function(ChatDispose value)? dispose,
    required TResult orElse(),
  }) {
    if (sendMessage != null) {
      return sendMessage(this);
    }
    return orElse();
  }
}

abstract class ChatSendMessage implements ChatEvent {
  const factory ChatSendMessage({required final String text}) =
      _$ChatSendMessageImpl;

  String get text;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatSendMessageImplCopyWith<_$ChatSendMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatMessageReceivedImplCopyWith<$Res> {
  factory _$$ChatMessageReceivedImplCopyWith(
    _$ChatMessageReceivedImpl value,
    $Res Function(_$ChatMessageReceivedImpl) then,
  ) = __$$ChatMessageReceivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({dynamic message});
}

/// @nodoc
class __$$ChatMessageReceivedImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatMessageReceivedImpl>
    implements _$$ChatMessageReceivedImplCopyWith<$Res> {
  __$$ChatMessageReceivedImplCopyWithImpl(
    _$ChatMessageReceivedImpl _value,
    $Res Function(_$ChatMessageReceivedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed}) {
    return _then(
      _$ChatMessageReceivedImpl(
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$ChatMessageReceivedImpl implements ChatMessageReceived {
  const _$ChatMessageReceivedImpl({required this.message});

  @override
  final dynamic message;

  @override
  String toString() {
    return 'ChatEvent.messageReceived(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageReceivedImpl &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageReceivedImplCopyWith<_$ChatMessageReceivedImpl> get copyWith =>
      __$$ChatMessageReceivedImplCopyWithImpl<_$ChatMessageReceivedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, bool isCaller)
    initializeConnection,
    required TResult Function(String text) sendMessage,
    required TResult Function(dynamic message) messageReceived,
    required TResult Function(dynamic connectionState) connectionStateChanged,
    required TResult Function(String error) errorOccurred,
    required TResult Function() dispose,
  }) {
    return messageReceived(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, bool isCaller)? initializeConnection,
    TResult? Function(String text)? sendMessage,
    TResult? Function(dynamic message)? messageReceived,
    TResult? Function(dynamic connectionState)? connectionStateChanged,
    TResult? Function(String error)? errorOccurred,
    TResult? Function()? dispose,
  }) {
    return messageReceived?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, bool isCaller)? initializeConnection,
    TResult Function(String text)? sendMessage,
    TResult Function(dynamic message)? messageReceived,
    TResult Function(dynamic connectionState)? connectionStateChanged,
    TResult Function(String error)? errorOccurred,
    TResult Function()? dispose,
    required TResult orElse(),
  }) {
    if (messageReceived != null) {
      return messageReceived(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitializeConnection value)
    initializeConnection,
    required TResult Function(ChatSendMessage value) sendMessage,
    required TResult Function(ChatMessageReceived value) messageReceived,
    required TResult Function(ChatConnectionStateChanged value)
    connectionStateChanged,
    required TResult Function(ChatErrorOccurred value) errorOccurred,
    required TResult Function(ChatDispose value) dispose,
  }) {
    return messageReceived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitializeConnection value)? initializeConnection,
    TResult? Function(ChatSendMessage value)? sendMessage,
    TResult? Function(ChatMessageReceived value)? messageReceived,
    TResult? Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult? Function(ChatErrorOccurred value)? errorOccurred,
    TResult? Function(ChatDispose value)? dispose,
  }) {
    return messageReceived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitializeConnection value)? initializeConnection,
    TResult Function(ChatSendMessage value)? sendMessage,
    TResult Function(ChatMessageReceived value)? messageReceived,
    TResult Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult Function(ChatErrorOccurred value)? errorOccurred,
    TResult Function(ChatDispose value)? dispose,
    required TResult orElse(),
  }) {
    if (messageReceived != null) {
      return messageReceived(this);
    }
    return orElse();
  }
}

abstract class ChatMessageReceived implements ChatEvent {
  const factory ChatMessageReceived({required final dynamic message}) =
      _$ChatMessageReceivedImpl;

  dynamic get message;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageReceivedImplCopyWith<_$ChatMessageReceivedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatConnectionStateChangedImplCopyWith<$Res> {
  factory _$$ChatConnectionStateChangedImplCopyWith(
    _$ChatConnectionStateChangedImpl value,
    $Res Function(_$ChatConnectionStateChangedImpl) then,
  ) = __$$ChatConnectionStateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({dynamic connectionState});
}

/// @nodoc
class __$$ChatConnectionStateChangedImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatConnectionStateChangedImpl>
    implements _$$ChatConnectionStateChangedImplCopyWith<$Res> {
  __$$ChatConnectionStateChangedImplCopyWithImpl(
    _$ChatConnectionStateChangedImpl _value,
    $Res Function(_$ChatConnectionStateChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? connectionState = freezed}) {
    return _then(
      _$ChatConnectionStateChangedImpl(
        connectionState: freezed == connectionState
            ? _value.connectionState
            : connectionState // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$ChatConnectionStateChangedImpl implements ChatConnectionStateChanged {
  const _$ChatConnectionStateChangedImpl({required this.connectionState});

  @override
  final dynamic connectionState;

  @override
  String toString() {
    return 'ChatEvent.connectionStateChanged(connectionState: $connectionState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatConnectionStateChangedImpl &&
            const DeepCollectionEquality().equals(
              other.connectionState,
              connectionState,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(connectionState),
  );

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatConnectionStateChangedImplCopyWith<_$ChatConnectionStateChangedImpl>
  get copyWith =>
      __$$ChatConnectionStateChangedImplCopyWithImpl<
        _$ChatConnectionStateChangedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, bool isCaller)
    initializeConnection,
    required TResult Function(String text) sendMessage,
    required TResult Function(dynamic message) messageReceived,
    required TResult Function(dynamic connectionState) connectionStateChanged,
    required TResult Function(String error) errorOccurred,
    required TResult Function() dispose,
  }) {
    return connectionStateChanged(connectionState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, bool isCaller)? initializeConnection,
    TResult? Function(String text)? sendMessage,
    TResult? Function(dynamic message)? messageReceived,
    TResult? Function(dynamic connectionState)? connectionStateChanged,
    TResult? Function(String error)? errorOccurred,
    TResult? Function()? dispose,
  }) {
    return connectionStateChanged?.call(connectionState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, bool isCaller)? initializeConnection,
    TResult Function(String text)? sendMessage,
    TResult Function(dynamic message)? messageReceived,
    TResult Function(dynamic connectionState)? connectionStateChanged,
    TResult Function(String error)? errorOccurred,
    TResult Function()? dispose,
    required TResult orElse(),
  }) {
    if (connectionStateChanged != null) {
      return connectionStateChanged(connectionState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitializeConnection value)
    initializeConnection,
    required TResult Function(ChatSendMessage value) sendMessage,
    required TResult Function(ChatMessageReceived value) messageReceived,
    required TResult Function(ChatConnectionStateChanged value)
    connectionStateChanged,
    required TResult Function(ChatErrorOccurred value) errorOccurred,
    required TResult Function(ChatDispose value) dispose,
  }) {
    return connectionStateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitializeConnection value)? initializeConnection,
    TResult? Function(ChatSendMessage value)? sendMessage,
    TResult? Function(ChatMessageReceived value)? messageReceived,
    TResult? Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult? Function(ChatErrorOccurred value)? errorOccurred,
    TResult? Function(ChatDispose value)? dispose,
  }) {
    return connectionStateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitializeConnection value)? initializeConnection,
    TResult Function(ChatSendMessage value)? sendMessage,
    TResult Function(ChatMessageReceived value)? messageReceived,
    TResult Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult Function(ChatErrorOccurred value)? errorOccurred,
    TResult Function(ChatDispose value)? dispose,
    required TResult orElse(),
  }) {
    if (connectionStateChanged != null) {
      return connectionStateChanged(this);
    }
    return orElse();
  }
}

abstract class ChatConnectionStateChanged implements ChatEvent {
  const factory ChatConnectionStateChanged({
    required final dynamic connectionState,
  }) = _$ChatConnectionStateChangedImpl;

  dynamic get connectionState;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatConnectionStateChangedImplCopyWith<_$ChatConnectionStateChangedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatErrorOccurredImplCopyWith<$Res> {
  factory _$$ChatErrorOccurredImplCopyWith(
    _$ChatErrorOccurredImpl value,
    $Res Function(_$ChatErrorOccurredImpl) then,
  ) = __$$ChatErrorOccurredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$ChatErrorOccurredImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatErrorOccurredImpl>
    implements _$$ChatErrorOccurredImplCopyWith<$Res> {
  __$$ChatErrorOccurredImplCopyWithImpl(
    _$ChatErrorOccurredImpl _value,
    $Res Function(_$ChatErrorOccurredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$ChatErrorOccurredImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChatErrorOccurredImpl implements ChatErrorOccurred {
  const _$ChatErrorOccurredImpl({required this.error});

  @override
  final String error;

  @override
  String toString() {
    return 'ChatEvent.errorOccurred(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatErrorOccurredImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatErrorOccurredImplCopyWith<_$ChatErrorOccurredImpl> get copyWith =>
      __$$ChatErrorOccurredImplCopyWithImpl<_$ChatErrorOccurredImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, bool isCaller)
    initializeConnection,
    required TResult Function(String text) sendMessage,
    required TResult Function(dynamic message) messageReceived,
    required TResult Function(dynamic connectionState) connectionStateChanged,
    required TResult Function(String error) errorOccurred,
    required TResult Function() dispose,
  }) {
    return errorOccurred(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, bool isCaller)? initializeConnection,
    TResult? Function(String text)? sendMessage,
    TResult? Function(dynamic message)? messageReceived,
    TResult? Function(dynamic connectionState)? connectionStateChanged,
    TResult? Function(String error)? errorOccurred,
    TResult? Function()? dispose,
  }) {
    return errorOccurred?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, bool isCaller)? initializeConnection,
    TResult Function(String text)? sendMessage,
    TResult Function(dynamic message)? messageReceived,
    TResult Function(dynamic connectionState)? connectionStateChanged,
    TResult Function(String error)? errorOccurred,
    TResult Function()? dispose,
    required TResult orElse(),
  }) {
    if (errorOccurred != null) {
      return errorOccurred(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitializeConnection value)
    initializeConnection,
    required TResult Function(ChatSendMessage value) sendMessage,
    required TResult Function(ChatMessageReceived value) messageReceived,
    required TResult Function(ChatConnectionStateChanged value)
    connectionStateChanged,
    required TResult Function(ChatErrorOccurred value) errorOccurred,
    required TResult Function(ChatDispose value) dispose,
  }) {
    return errorOccurred(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitializeConnection value)? initializeConnection,
    TResult? Function(ChatSendMessage value)? sendMessage,
    TResult? Function(ChatMessageReceived value)? messageReceived,
    TResult? Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult? Function(ChatErrorOccurred value)? errorOccurred,
    TResult? Function(ChatDispose value)? dispose,
  }) {
    return errorOccurred?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitializeConnection value)? initializeConnection,
    TResult Function(ChatSendMessage value)? sendMessage,
    TResult Function(ChatMessageReceived value)? messageReceived,
    TResult Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult Function(ChatErrorOccurred value)? errorOccurred,
    TResult Function(ChatDispose value)? dispose,
    required TResult orElse(),
  }) {
    if (errorOccurred != null) {
      return errorOccurred(this);
    }
    return orElse();
  }
}

abstract class ChatErrorOccurred implements ChatEvent {
  const factory ChatErrorOccurred({required final String error}) =
      _$ChatErrorOccurredImpl;

  String get error;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatErrorOccurredImplCopyWith<_$ChatErrorOccurredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatDisposeImplCopyWith<$Res> {
  factory _$$ChatDisposeImplCopyWith(
    _$ChatDisposeImpl value,
    $Res Function(_$ChatDisposeImpl) then,
  ) = __$$ChatDisposeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChatDisposeImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatDisposeImpl>
    implements _$$ChatDisposeImplCopyWith<$Res> {
  __$$ChatDisposeImplCopyWithImpl(
    _$ChatDisposeImpl _value,
    $Res Function(_$ChatDisposeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChatDisposeImpl implements ChatDispose {
  const _$ChatDisposeImpl();

  @override
  String toString() {
    return 'ChatEvent.dispose()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChatDisposeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, bool isCaller)
    initializeConnection,
    required TResult Function(String text) sendMessage,
    required TResult Function(dynamic message) messageReceived,
    required TResult Function(dynamic connectionState) connectionStateChanged,
    required TResult Function(String error) errorOccurred,
    required TResult Function() dispose,
  }) {
    return dispose();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, bool isCaller)? initializeConnection,
    TResult? Function(String text)? sendMessage,
    TResult? Function(dynamic message)? messageReceived,
    TResult? Function(dynamic connectionState)? connectionStateChanged,
    TResult? Function(String error)? errorOccurred,
    TResult? Function()? dispose,
  }) {
    return dispose?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, bool isCaller)? initializeConnection,
    TResult Function(String text)? sendMessage,
    TResult Function(dynamic message)? messageReceived,
    TResult Function(dynamic connectionState)? connectionStateChanged,
    TResult Function(String error)? errorOccurred,
    TResult Function()? dispose,
    required TResult orElse(),
  }) {
    if (dispose != null) {
      return dispose();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitializeConnection value)
    initializeConnection,
    required TResult Function(ChatSendMessage value) sendMessage,
    required TResult Function(ChatMessageReceived value) messageReceived,
    required TResult Function(ChatConnectionStateChanged value)
    connectionStateChanged,
    required TResult Function(ChatErrorOccurred value) errorOccurred,
    required TResult Function(ChatDispose value) dispose,
  }) {
    return dispose(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitializeConnection value)? initializeConnection,
    TResult? Function(ChatSendMessage value)? sendMessage,
    TResult? Function(ChatMessageReceived value)? messageReceived,
    TResult? Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult? Function(ChatErrorOccurred value)? errorOccurred,
    TResult? Function(ChatDispose value)? dispose,
  }) {
    return dispose?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitializeConnection value)? initializeConnection,
    TResult Function(ChatSendMessage value)? sendMessage,
    TResult Function(ChatMessageReceived value)? messageReceived,
    TResult Function(ChatConnectionStateChanged value)? connectionStateChanged,
    TResult Function(ChatErrorOccurred value)? errorOccurred,
    TResult Function(ChatDispose value)? dispose,
    required TResult orElse(),
  }) {
    if (dispose != null) {
      return dispose(this);
    }
    return orElse();
  }
}

abstract class ChatDispose implements ChatEvent {
  const factory ChatDispose() = _$ChatDisposeImpl;
}
