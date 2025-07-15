import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/service_locator.dart';
import '../data/room_remote_data_source.dart';
import 'room_selection_bloc.dart';

class RoomSelectionPage extends StatelessWidget {
  const RoomSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RoomSelectionBloc(roomDataSource: getIt<RoomRemoteDataSource>()),
      child: const RoomSelectionView(),
    );
  }
}

class RoomSelectionView extends StatelessWidget {
  const RoomSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Selection'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<RoomSelectionBloc, RoomSelectionState>(
        listener: (context, state) {
          if (state is RoomWaitingAnswer) {
            _showRoomCreatedDialog(context, state.roomId);
          } else if (state is RoomError) {
            _showErrorDialog(context, state.message);
          } else if (state is RoomConnected) {
            // Navigate to chat page when room is connected
            context.go('/chat/${state.roomId}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.video_call, size: 80, color: Colors.teal),
              const SizedBox(height: 32),
              const Text(
                'Welcome to GlobGram P2P',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Create a new room or join an existing one',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              BlocBuilder<RoomSelectionBloc, RoomSelectionState>(
                builder: (context, state) {
                  final isLoading =
                      state is RoomCreating || state is RoomConnecting;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _createRoom(context),
                        icon: isLoading && state is RoomCreating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.add),
                        label: Text(
                          isLoading && state is RoomCreating
                              ? 'Creating Room...'
                              : 'Create Room',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _showJoinRoomDialog(context),
                        icon: isLoading && state is RoomConnecting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: Text(
                          isLoading && state is RoomConnecting
                              ? 'Joining Room...'
                              : 'Join Room',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal.shade300,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<RoomSelectionBloc, RoomSelectionState>(
                builder: (context, state) {
                  if (state is RoomWaitingAnswer) {
                    return Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Room Created!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Room ID: ${state.roomId}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is RoomConnected) {
                    return Card(
                      color: Colors.blue.shade50,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.videocam, color: Colors.blue, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Connected to Room!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createRoom(BuildContext context) {
    context.read<RoomSelectionBloc>().add(const CreateRequested());
  }

  void _showJoinRoomDialog(BuildContext context) {
    final roomIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Join Room'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the Room ID to join:'),
            const SizedBox(height: 16),
            TextFormField(
              controller: roomIdController,
              decoration: const InputDecoration(
                labelText: 'Room ID',
                hintText: 'e.g., ROOM123',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key),
              ),
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                LengthLimitingTextInputFormatter(8),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final roomId = roomIdController.text.trim();
              if (roomId.isNotEmpty) {
                Navigator.of(dialogContext).pop();
                context.read<RoomSelectionBloc>().add(JoinRequested(roomId));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _showRoomCreatedDialog(BuildContext context, String roomId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
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
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<RoomSelectionBloc>().add(const ClearRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<RoomSelectionBloc>().add(const ClearRequested());
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
