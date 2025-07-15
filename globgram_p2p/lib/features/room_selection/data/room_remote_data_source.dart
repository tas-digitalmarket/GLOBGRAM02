import 'dart:async';
import 'dart:math';
import '../domain/room_entity.dart';

abstract class RoomRemoteDataSource {
  Future<String> createRoom();
  Future<void> joinRoom(String roomId);
  Future<void> closeRoom(String roomId);
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final Map<String, RoomEntity> _rooms = {};
  
  @override
  Future<String> createRoom() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate random room ID
    final roomId = _generateRoomId();
    final room = RoomEntity(
      roomId: roomId,
      createdAt: DateTime.now(),
    );
    
    _rooms[roomId] = room;
    return roomId;
  }

  @override
  Future<void> joinRoom(String roomId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (!_rooms.containsKey(roomId)) {
      throw Exception('Room not found: $roomId');
    }
    
    // In a real implementation, this would handle WebRTC signaling
    // For now, just simulate successful join
  }

  @override
  Future<void> closeRoom(String roomId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (!_rooms.containsKey(roomId)) {
      throw Exception('Room not found: $roomId');
    }
    
    _rooms.remove(roomId);
  }

  String _generateRoomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
