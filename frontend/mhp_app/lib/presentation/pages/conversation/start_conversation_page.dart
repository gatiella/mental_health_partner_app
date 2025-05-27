import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/config/routes.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_event.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_state.dart';

class StartConversationPage extends StatefulWidget {
  const StartConversationPage({super.key});

  @override
  State<StartConversationPage> createState() => _StartConversationPageState();
}

class _StartConversationPageState extends State<StartConversationPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  Timer? _loadingTimeout;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.1).animate(_animationController);

    // Load conversations
    context.read<ConversationBloc>().add(LoadConversations());
  }

  void _startConversation(BuildContext context) {
    _animationController.forward();
    setState(() => _isLoading = true);

    _loadingTimeout = Timer(const Duration(seconds: 60), () {
      _resetButton();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request timeout. Please try again.")),
      );
    });

    context.read<ConversationBloc>().add(StartNewConversation());
  }

  void _resetButton() {
    if (mounted) {
      setState(() => _isLoading = false);
      _animationController.reverse();
      _loadingTimeout?.cancel();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loadingTimeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversations')),
      body: BlocConsumer<ConversationBloc, ConversationState>(
        listener: (context, state) {
          if (state is ConversationStarted) {
            _loadingTimeout?.cancel();
            Navigator.pushReplacementNamed(
              context,
              AppRouter.conversationRoute,
              arguments: state.conversation.id,
            );
          } else if (state is ConversationError) {
            _resetButton();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ConversationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConversationsLoaded) {
            final conversations = state.conversations;

            if (conversations.isEmpty) {
              return const Center(child: Text('No previous conversations.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final lastMessage = conversation.messages.isNotEmpty
                    ? conversation.messages.last
                    : null;

                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.chat, color: Colors.white),
                    ),
                    title: Text(
                      'Conversation ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: lastMessage != null
                        ? Text(
                            lastMessage.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const Text('No messages'),
                    trailing: lastMessage != null
                        ? Text(
                            _formatDate(lastMessage.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.conversationRoute,
                        arguments: conversation.id,
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is ConversationError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(
              child: Text(
                'Ready to start a new conversation?',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: _isLoading ? null : () => _startConversation(context),
          label: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Start New Chat'),
          icon: _isLoading ? null : const Icon(Icons.add_comment_rounded),
          backgroundColor:
              _isLoading ? Colors.grey : Theme.of(context).primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Today: show time
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week: show day name
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[date.weekday - 1];
    } else {
      // Older: show date
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
