import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_state.dart';
import 'package:globgram_p2p/features/chat/presentation/message_bubble.dart';
import 'package:globgram_p2p/features/chat/presentation/widgets/connection_status_widget.dart';
import 'package:globgram_p2p/core/service_locator.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final bool asCaller;

  const ChatPage({super.key, required this.roomId, required this.asCaller});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static final Logger _logger = Logger();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _lastErrorShown; // Track last error message to avoid duplicate snackbars

  @override
  void initState() {
    super.initState();
    debugPrint("ChatPage asCaller=${widget.asCaller}");
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room: ${widget.roomId}'),
            Text(
              widget.asCaller ? 'Caller' : 'Joiner',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: () {
                final webrtcService = getIt<WebRTCService>();
                final debugInfo = webrtcService.getDebugInfo();
                debugPrint('WebRTC Debug Info: $debugInfo');
              },
              tooltip: 'Debug WebRTC Connection',
            ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ConnectionStatusWidget(state: state),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // TODO: Add media controls section here when implementing audio/video features
          // This would include:
          // - Local video preview widget
          // - Audio/video toggle buttons
          // - Remote video display area
          // - Camera switch button (front/back)
          // Example layout:
          // if (mediaEnabled) MediaControlsWidget(webrtcService: webrtcService),
          
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                state.whenOrNull(
                  connected: (roomId, isCaller, messages) {
                    if (messages.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                    }
                  },
                  error: (message) {
                    // Show error snackbar only once per unique error message
                    if (_lastErrorShown != message) {
                      _lastErrorShown = message;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${'error.generic'.tr()}: $message'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 4),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            action: SnackBarAction(
                              label: 'common.dismiss'.tr(),
                              textColor: Colors.white,
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                      });
                    }
                  },
                );
              },
              builder: (context, state) {
                return state.when(
                  initial: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text('chat.messages.initializing'.tr()),
                      ],
                    ),
                  ),
                  connecting: (roomId, isCaller) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text('chat.messages.connecting'.tr()),
                      ],
                    ),
                  ),
                  connected: (roomId, isCaller, messages) {
                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'chat.messages.empty'.tr(),
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'chat.messages.start'.tr(),
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.separated(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: messages.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final reversedIndex = messages.length - 1 - index;
                        final message = messages[reversedIndex];
                        return MessageBubble(
                          msg: message,
                          isMine: message.sender == ChatSender.self,
                        );
                      },
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${'error.generic'.tr()}: $message',
                          style: const TextStyle(fontSize: 18, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  disconnected: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'chat.status.disconnected'.tr(),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
                  ),
            ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final isReady = state.maybeWhen(
                connected: (_, __, ___) => true,
                orElse: () => false,
              );
              
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 0.5),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_emotions_outlined,
                        color: isReady
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          enabled: isReady,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: isReady
                                ? 'chat.input.hint'.tr()
                                : 'chat.status.connecting'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          onSubmitted: isReady ? _sendMessage : null,
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.attach_file,
                        color: isReady
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: isReady
                            ? () => _sendMessage(_messageController.text)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isReady
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      _logger.i('[🚀] Sending message: ${text.trim()}');
      try {
        context.read<ChatBloc>().sendMessage(text.trim());
        _messageController.clear();
        _logger.i('[🚀] Message sent successfully');
      } catch (error) {
        _logger.e('[🐛] Error sending message: $error');
      }
    }
  }
}
