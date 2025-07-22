import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_state.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final ChatState state;

  const ConnectionStatusWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final (text, color) = state.when(
      initial: () => ('chat.status.initializing'.tr(), Colors.grey),
      connecting: (_, __) => ('chat.status.connecting'.tr(), Colors.amber),
      connected: (_, __, ___) => ('chat.status.connected'.tr(), Colors.green),
      error: (_) => ('chat.status.error'.tr(), Colors.red),
      disconnected: () => ('chat.status.disconnected'.tr(), Colors.grey),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
