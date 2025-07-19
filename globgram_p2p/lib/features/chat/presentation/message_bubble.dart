import 'package:flutter/material.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool isMine;

  const MessageBubble({
    super.key,
    required this.msg,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xFFE1FFC7) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isMine ? const Radius.circular(4) : null,
            bottomLeft: !isMine ? const Radius.circular(4) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg.text, style: const TextStyle(color: Colors.black87, fontSize: 16)),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(_formatTime(msg.timestamp), style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
