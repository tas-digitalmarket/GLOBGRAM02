import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool isMine;

  const MessageBubble({super.key, required this.msg, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showTimestampTooltip(context),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isMine 
                ? colorScheme.primaryContainer 
                : colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(18).copyWith(
              bottomRight: isMine ? const Radius.circular(4) : null,
              bottomLeft: !isMine ? const Radius.circular(4) : null,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg.text,
                style: TextStyle(
                  color: isMine 
                      ? colorScheme.onPrimaryContainer 
                      : colorScheme.onSecondaryContainer,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _formatTime(msg.timestamp),
                  style: TextStyle(
                    color: (isMine 
                        ? colorScheme.onPrimaryContainer 
                        : colorScheme.onSecondaryContainer).withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showTimestampTooltip(BuildContext context) {
    final formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(msg.timestamp);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sent at: $formattedTimestamp'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
