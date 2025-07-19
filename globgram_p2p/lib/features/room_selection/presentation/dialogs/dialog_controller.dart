import 'package:flutter/material.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/error_room_dialog.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/join_room_dialog.dart';
import 'package:globgram_p2p/features/room_selection/presentation/dialogs/loading_room_dialog.dart';

/// Controller for managing room selection dialogs
/// Provides safer loading dialog management with context tracking
class RoomDialogController {
  BuildContext? _loadingDialogContext;

  /// Shows a loading dialog with the specified message
  /// If a loading dialog is already shown, this is a no-op
  void showLoadingDialog(BuildContext context, String message) {
    // If loading dialog already shown, do nothing
    if (_loadingDialogContext != null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Capture dialog context for safe dismissal
        _loadingDialogContext = dialogContext;
        return LoadingRoomDialog(message: message);
      },
    );
  }

  /// Safely dismisses the loading dialog if one is currently shown
  /// Uses specific dialog context to avoid popping unrelated routes
  void dismissLoadingDialog() {
    if (_loadingDialogContext != null) {
      final context = _loadingDialogContext!;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _loadingDialogContext = null;
    }
  }

  /// Shows an error dialog with retry/dismiss actions
  void showErrorDialog(
    BuildContext context, {
    required String message,
    required VoidCallback onDismiss,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => ErrorRoomDialog(
        message: message,
        onDismiss: () {
          Navigator.of(dialogContext).pop();
          onDismiss();
        },
      ),
    );
  }

  /// Shows the join room dialog for entering room ID
  void showJoinDialog(
    BuildContext context, {
    required Function(String roomId) onJoin,
    required VoidCallback onCancel,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => JoinRoomDialog(
        onJoin: (String roomId) {
          Navigator.of(dialogContext).pop();
          onJoin(roomId);
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
          onCancel();
        },
      ),
    );
  }

  /// Returns whether a loading dialog is currently shown
  bool get isLoadingDialogShown => _loadingDialogContext != null;

  /// Cleans up dialog context references
  /// Should be called when the parent widget is disposed
  void dispose() {
    _loadingDialogContext = null;
  }
}
