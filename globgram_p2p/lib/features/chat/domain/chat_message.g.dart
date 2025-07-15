// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      sender: $enumDecode(_$ChatSenderEnumMap, json['sender']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'sender': _$ChatSenderEnumMap[instance.sender]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$ChatSenderEnumMap = {ChatSender.self: 'self', ChatSender.peer: 'peer'};
