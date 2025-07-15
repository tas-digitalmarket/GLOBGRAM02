import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum ChatSender {
  @JsonValue('self')
  self,
  @JsonValue('peer')
  peer,
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required ChatSender sender,
    required DateTime timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  /// Create a message from self
  factory ChatMessage.fromSelf({
    required String id,
    required String text,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id,
      text: text,
      sender: ChatSender.self,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  /// Create a message from peer
  factory ChatMessage.fromPeer({
    required String id,
    required String text,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id,
      text: text,
      sender: ChatSender.peer,
      timestamp: timestamp ?? DateTime.now(),
    );
  }
}

extension ChatMessageExtension on ChatMessage {
  /// Check if message is from self
  bool get isFromSelf => sender == ChatSender.self;

  /// Check if message is from peer
  bool get isFromPeer => sender == ChatSender.peer;

  /// Get formatted timestamp
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inHours > 0) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
