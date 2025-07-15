import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';
import 'package:globgram_p2p/core/service_locator.dart';

class ChatPage extends StatefulWidget {
  final String roomId;

  const ChatPage({super.key, required this.roomId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static final Logger _logger = Logger();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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

  IconData _getConnectionIcon(ChatState state) {
    if (state is ChatReady) return Icons.check_circle;
    if (state is ChatConnecting) return Icons.flash_on;
    return Icons.pause_circle_outline;
  }

  Color _getConnectionColor(ChatState state) {
    if (state is ChatReady) return Colors.green;
    if (state is ChatConnecting) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (context) {
        final chatBloc = getIt<ChatBloc>();
        chatBloc.initializeConnection(widget.roomId, asCaller: true);
        return chatBloc;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Room: ${widget.roomId}'),
          actions: [
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    _getConnectionIcon(state),
                    color: _getConnectionColor(state),
                    size: 24,
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatReady && state.history.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ChatReady) {
                    if (state.history.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No messages yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                            SizedBox(height: 8),
                            Text('Start the conversation! 💬', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.history.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final reversedIndex = state.history.length - 1 - index;
                        final message = state.history[reversedIndex];
                        return _buildMessageBubble(message);
                      },
                    );
                  }
                  
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Connecting to chat...'),
                      ],
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                final isReady = state is ChatReady;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Icon(Icons.emoji_emotions_outlined, color: isReady ? Colors.grey.shade600 : Colors.grey.shade400, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            enabled: isReady,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: isReady ? 'Type a message...' : 'Connecting...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            onSubmitted: isReady ? _sendMessage : null,
                            textInputAction: TextInputAction.send,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.attach_file, color: isReady ? Colors.grey.shade600 : Colors.grey.shade400, size: 24),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: isReady ? () => _sendMessage(_messageController.text) : null,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isReady ? Theme.of(context).primaryColor : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send, color: Colors.white, size: 20),
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
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isSelf = message.sender == ChatSender.self;
    
    return Align(
      alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelf ? const Color(0xFFE1FFC7) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isSelf ? const Radius.circular(4) : null,
            bottomLeft: !isSelf ? const Radius.circular(4) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.text, style: const TextStyle(color: Colors.black87, fontSize: 16)),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(_formatTime(message.timestamp), style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
