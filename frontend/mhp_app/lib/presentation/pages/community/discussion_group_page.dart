// lib/presentation/pages/community/discussion_group_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_state.dart';
import 'package:mental_health_partner/presentation/pages/community/forum_thread_detail_page.dart';
import 'package:mental_health_partner/presentation/widgets/community/forum_thread_card.dart';

class DiscussionGroupPage extends StatelessWidget {
  final String groupSlug;

  const DiscussionGroupPage({super.key, required this.groupSlug});

  @override
  Widget build(BuildContext context) {
    // Load forum threads for this group slug
    context.read<CommunityBloc>().add(LoadForumThreads(groupId: groupSlug));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Discussions'),
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showCreateThreadDialog(context),
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state is CommunityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ForumThreadsLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.threads.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final thread = state.threads[index];
                return ForumThreadCard(
                  thread: thread,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ForumThreadDetailPage(threadId: thread.id),
                    ),
                  ),
                );
              },
            );
          } else if (state is CommunityError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showCreateThreadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Discussion Thread'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Thread Title'),
          onSubmitted: (title) {
            context.read<CommunityBloc>().add(
                  CreateForumThread(title: title, groupId: groupSlug),
                );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
