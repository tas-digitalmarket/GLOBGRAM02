import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
      title: Text('room.join.dialog.title'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('room.join.dialog.message'.tr()),
          const SizedBox(height: 16),
          TextFormField(
            controller: _roomIdController,
            decoration: InputDecoration(
              labelText: 'room.join.dialog.label'.tr(),
              hintText: 'room.join.dialog.hint'.tr(),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.vpn_key),
            ),
            maxLines: 1,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: widget.onCancel, child: Text('room.join.dialog.cancel'.tr())),
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
