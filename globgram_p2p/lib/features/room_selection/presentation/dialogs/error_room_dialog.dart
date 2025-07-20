import 'package:flutter/material.dart';

class ErrorRoomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const ErrorRoomDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [TextButton(onPressed: onDismiss, child: const Text('OK'))],
    );
  }
}
