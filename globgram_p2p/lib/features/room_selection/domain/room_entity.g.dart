// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomEntityImpl _$$RoomEntityImplFromJson(Map<String, dynamic> json) =>
    _$RoomEntityImpl(
      roomId: json['roomId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RoomEntityImplToJson(_$RoomEntityImpl instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
