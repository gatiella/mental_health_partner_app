import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_event.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_state.dart';
import 'package:mental_health_partner/presentation/blocs/gamification/gamification_bloc.dart';
import '../../widgets/conversation/message_bubble.dart';
import '../../widgets/gamification/quest_indicator.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  const ConversationPage({super.key, required this.conversationId});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Load conversation data when the page initializes
    Future.microtask(
        () => context.read<ConversationBloc>().add(LoadConversations()));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _handleTyping(String value) {
    if (value.isNotEmpty && !_isTyping) {
      setState(() => _isTyping = true);
    } else if (value.isEmpty && _isTyping) {
      setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<GamificationBloc, GamificationState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      state is PointsLoaded
                          ? '${state.points.currentPoints}'
                          : '0',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Quest progress indicator
            const QuestIndicator(),

            // Messages area
            Expanded(
              child: BlocConsumer<ConversationBloc, ConversationState>(
                listener: (context, state) {
                  if (state is MessageSent) {
                    // Award points for message
                    context
                        .read<GamificationBloc>()
                        .add(const AddPoints(points: 5));

                    setState(() => _isSending = false);
                    _scrollToBottom();
                  } else if (state is ConversationError) {
                    setState(() => _isSending = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ConversationLoading ||
                      state is ConversationInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ConversationsLoaded) {
                    // Find the current conversation
                    final currentConversation = state.conversations
                        .where((c) => c.id == widget.conversationId)
                        .toList();

                    if (currentConversation.isEmpty) {
                      return const Center(
                          child: Text('Conversation not found'));
                    }

                    final messages = currentConversation.first.messages
                        .toList()
                        .reversed
                        .toList();

                    return messages.isEmpty
                        ? const Center(child: Text('Start the conversation!'))
                        : ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            itemCount: messages.length,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemBuilder: (context, index) => MessageBubble(
                              message: messages[index],
                              isUserMessage: messages[index].isUserMessage,
                            ),
                          );
                  }
                  return const Center(child: Text('Unknown state'));
                },
              ),
            ),

            // Typing indicator
            if (_isTyping) _buildTypingIndicator(),

            // Message input box
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          Icon(Icons.more_horiz, color: Colors.grey),
          SizedBox(width: 8),
          Text('Typing...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: _handleTyping,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isSending ? null : _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    _isSending ? Colors.grey : Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      setState(() {
        _isSending = true;
        _isTyping = false;
      });
      context.read<ConversationBloc>().add(
            SendMessageEvent(
              conversationId: widget.conversationId,
              content: content,
            ),
          );
      _messageController.clear();
    }
  }
}
