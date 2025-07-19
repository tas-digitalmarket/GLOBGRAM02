import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/features/chat/domain/chat_message.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';
import 'package:globgram_p2p/features/chat/presentation/message_bubble.dart';

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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
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
                        return MessageBubble(
                          msg: message,
                          isMine: message.sender == ChatSender.self,
                        );
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
