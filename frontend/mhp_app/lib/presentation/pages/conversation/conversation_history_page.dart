import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/config/routes.dart';
import 'package:mental_health_partner/di/injection_container.dart'; // Import the service locator
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_event.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_state.dart';

class ConversationHistoryPage extends StatelessWidget {
  const ConversationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation History')),
      body: BlocProvider(
        create: (context) => sl<ConversationBloc>()..add(LoadConversations()),
        child: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            if (state is ConversationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ConversationsLoaded) {
              return state.conversations.isEmpty
                  ? const Center(child: Text('No conversations yet'))
                  : ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        return ListTile(
                          title: Text('Conversation ${index + 1}'),
                          subtitle: conversation.messages.isNotEmpty
                              ? Text(
                                  conversation.messages.last.content,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const Text('No messages'),
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRouter.conversationRoute,
                            arguments: conversation.id,
                          ),
                        );
                      },
                    );
            } else if (state is ConversationError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.startConversationRoute);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
