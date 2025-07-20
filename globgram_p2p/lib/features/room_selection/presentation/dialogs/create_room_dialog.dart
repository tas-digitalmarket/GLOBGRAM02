import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateRoomDialog extends StatelessWidget {
  final String roomId;
  final VoidCallback onOk;
  final VoidCallback? onStartChat;

  const CreateRoomDialog({
    super.key,
    required this.roomId,
    required this.onOk,
    this.onStartChat,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Room Created!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your room has been created successfully.'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.vpn_key, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    roomId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: roomId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Room ID copied to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy Room ID',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Share this Room ID with others to let them join your room.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: onOk, child: const Text('OK')),
        if (onStartChat != null)
          ElevatedButton(
            onPressed: onStartChat,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Chat'),
          ),
      ],
    );
  }
}
