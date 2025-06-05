// lib/presentation/pages/community/success_stories_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_state.dart';
import 'package:mental_health_partner/presentation/widgets/community/success_story_card.dart';

class SuccessStoriesPage extends StatelessWidget {
  const SuccessStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success Stories'),
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showCreateStoryDialog(context),
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state is CommunityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SuccessStoriesLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.stories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final story = state.stories[index];
                return SuccessStoryCard(story: story);
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

  void _showCreateStoryDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Your Story'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Story',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CommunityBloc>().add(
                    CreateSuccessStory(
                      title: titleController.text,
                      content: contentController.text,
                      category: 'general',
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }
}
