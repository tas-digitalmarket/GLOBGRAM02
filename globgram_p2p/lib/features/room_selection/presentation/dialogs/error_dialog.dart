import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final VoidCallback onOk;

  const ErrorDialog({super.key, required this.message, required this.onOk});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Text('Error'),
        ],
      ),
      content: Text(message),
      actions: [ElevatedButton(onPressed: onOk, child: const Text('OK'))],
    );
  }
}
