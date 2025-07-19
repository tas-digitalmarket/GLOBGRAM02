import 'package:flutter/material.dart';

class JoinRoomDialog extends StatefulWidget {
  final Function(String) onJoin;
  final VoidCallback onCancel;

  const JoinRoomDialog({
    super.key,
    required this.onJoin,
    required this.onCancel,
  });

  @override
  State<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  final TextEditingController _roomIdController = TextEditingController();

  @override
  void dispose() {
    _roomIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Room'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter the Room ID to join:'),
          const SizedBox(height: 16),
          TextFormField(
            controller: _roomIdController,
            decoration: const InputDecoration(
              labelText: 'Room ID',
              hintText: 'e.g., R907246',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vpn_key),
            ),
            maxLines: 1,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final roomId = _roomIdController.text.trim();
            if (roomId.isNotEmpty) {
              widget.onJoin(roomId);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: const Text('Join'),
        ),
      ],
    );
  }
}
