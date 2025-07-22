import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:globgram_p2p/core/service_locator.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_local_bloc.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_state.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_event.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/join_room_dialog.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/error_room_dialog.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/loading_room_dialog.dart';

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

class RoomSelectionView extends StatefulWidget {
  const RoomSelectionView({super.key});

  @override
  State<RoomSelectionView> createState() => _RoomSelectionViewState();
}

class _RoomSelectionViewState extends State<RoomSelectionView> {
  BuildContext? _loadingDialogContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('room.selection.title'.tr()),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              // Toggle between English and Farsi
              final currentLocale = context.locale;
              if (currentLocale.languageCode == 'en') {
                context.setLocale(const Locale('fa'));
              } else {
                context.setLocale(const Locale('en'));
              }
            },
            icon: const Icon(Icons.language),
            tooltip: 'language.toggle'.tr(),
          ),
        ],
      ),
      body: BlocListener<RoomSelectionLocalBloc, RoomSelectionState>(
        listener: (context, state) {
          state.when(
            idle: () => _dismissLoadingDialog(),
            creating: () => _showLoadingDialog(context, 'room.create.creating'.tr()),
            waitingAnswer: (roomId) => _showLoadingDialog(context, 'room.create.waiting'.tr()),
            joining: (roomId) => _showLoadingDialog(context, 'room.join.joining'.tr()),
            connected: (roomId, isCaller) {
              _dismissLoadingDialog();
              context.go('/chat/$roomId?asCaller=$isCaller');
            },
            failure: (message) {
              _dismissLoadingDialog();
              _showErrorDialog(context, message);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.video_call, size: 80, color: Colors.teal),
              const SizedBox(height: 32),
              Text(
                'common.welcome'.tr(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'common.subtitle'.tr(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              BlocBuilder<RoomSelectionLocalBloc, RoomSelectionState>(
                builder: (context, state) {
                  final isLoading = state.maybeWhen(
                    creating: () => true,
                    joining: (_) => true,
                    orElse: () => false,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _createRoom(context),
                        icon: const Icon(Icons.add),
                        label: Text('room.create.button'.tr()),
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
                            : () => _showJoinDialog(context),
                        icon: const Icon(Icons.login),
                        label: Text('room.join.button'.tr()),
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
                  return state.maybeWhen(
                    waitingAnswer: (roomId) => Card(
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
                            Text(
                              'room.create.success'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Room ID: $roomId',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    connected: (roomId, isCaller) => Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.videocam, color: Colors.blue, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'room.connected'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createRoom(BuildContext context) {
    context.read<RoomSelectionLocalBloc>().add(const RoomSelectionEvent.createRequested());
  }

  void _showJoinDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => JoinRoomDialog(
        onJoin: (String roomId) {
          Navigator.of(dialogContext).pop();
          if (mounted) {
            context.read<RoomSelectionLocalBloc>().add(RoomSelectionEvent.joinRequested(roomId: roomId));
          }
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => ErrorRoomDialog(
        message: message,
        onDismiss: () {
          Navigator.of(dialogContext).pop();
          if (mounted) {
            context.read<RoomSelectionLocalBloc>().add(const RoomSelectionEvent.clearRequested());
          }
        },
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, String message) {
    if (_loadingDialogContext != null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        _loadingDialogContext = dialogContext;
        return LoadingRoomDialog(message: message);
      },
    );
  }

  void _dismissLoadingDialog() {
    if (_loadingDialogContext != null) {
      if (Navigator.of(_loadingDialogContext!).canPop()) {
        Navigator.of(_loadingDialogContext!).pop();
      }
      _loadingDialogContext = null;
    }
  }
}
