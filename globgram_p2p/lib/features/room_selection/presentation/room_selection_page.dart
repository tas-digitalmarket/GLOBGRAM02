import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:globgram_p2p/core/service_locator.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_local_bloc.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/create_room_dialog.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/join_room_dialog.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/error_room_dialog.dart';

class RoomSelectionPage extends StatelessWidget {
  const RoomSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RoomSelectionLocalBloc>(),
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
      body: BlocListener<RoomSelectionLocalBloc, RoomSelectionState>(
        listener: (context, state) {
          if (state is RoomWaitingAnswer) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => CreateRoomDialog(
                roomId: state.roomId,
                onOk: () {
                  Navigator.of(dialogContext).pop();
                  context.read<RoomSelectionLocalBloc>().add(const ClearRequested());
                },
                onStartChat: () {
                  Navigator.of(dialogContext).pop();
                  context.go('/chat/${state.roomId}?asCaller=${state.isCaller}');
                },
              ),
            );
          } else if (state is RoomError) {
            showDialog(
              context: context,
              builder: (dialogContext) => ErrorRoomDialog(
                message: state.message,
                onDismiss: () {
                  Navigator.of(dialogContext).pop();
                  context.read<RoomSelectionLocalBloc>().add(const ClearRequested());
                },
              ),
            );
          } else if (state is RoomConnected) {
            // Navigate to chat page with appropriate caller flag
            context.go('/chat/${state.roomId}?asCaller=${state.isCaller}');
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
              BlocBuilder<RoomSelectionLocalBloc, RoomSelectionState>(
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
                            : () => showDialog(
                                  context: context,
                                  builder: (dialogContext) => JoinRoomDialog(
                                    onJoin: (roomId) {
                                      Navigator.of(dialogContext).pop();
                                      context.read<RoomSelectionLocalBloc>().add(JoinRequested(roomId));
                                    },
                                    onCancel: () => Navigator.of(dialogContext).pop(),
                                  ),
                                ),
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
              BlocBuilder<RoomSelectionLocalBloc, RoomSelectionState>(
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
    context.read<RoomSelectionLocalBloc>().add(const CreateRequested());
  }
}
