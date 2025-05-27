// Updated ForumThreadDetailPage with correct state handling
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_state.dart';
import 'package:mental_health_partner/presentation/widgets/community/forum_post_card.dart';

class ForumThreadDetailPage extends StatefulWidget {
  final String threadId;

  const ForumThreadDetailPage({super.key, required this.threadId});

  @override
  State<ForumThreadDetailPage> createState() => _ForumThreadDetailPageState();
}

class _ForumThreadDetailPageState extends State<ForumThreadDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load both thread details and posts
    context
        .read<CommunityBloc>()
        .add(LoadForumPosts(threadId: widget.threadId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion Thread'),
        elevation: 4,
      ),
      floatingActionButton: BlocSelector<CommunityBloc, CommunityState, bool>(
        selector: (state) {
          return state is ForumPostsLoaded ? !state.isThreadLocked : false;
        },
        builder: (context, isThreadUnlocked) {
          return isThreadUnlocked
              ? FloatingActionButton(
                  child: const Icon(Icons.add_comment),
                  onPressed: () => _showCreatePostDialog(context),
                )
              : const SizedBox.shrink();
        },
      ),
      body: BlocConsumer<CommunityBloc, CommunityState>(
        listener: (context, state) {
          if (state is CommunityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CommunityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ForumPostsLoaded) {
            return Column(
              children: [
                if (state.isThreadLocked) _buildLockedThreadBanner(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<CommunityBloc>()
                          .add(LoadForumPosts(threadId: widget.threadId));
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.posts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return ForumPostCard(
                          post: post,
                          onEncouragementPressed: () =>
                              context.read<CommunityBloc>().add(
                                    ToggleEncouragement(postId: post.id),
                                  ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Failed to load thread'));
        },
      ),
    );
  }

  Widget _buildLockedThreadBanner() {
    return Container(
      color: Colors.amber.shade100,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.lock, color: Colors.amber.shade800),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This thread is locked and cannot receive new posts',
              style: TextStyle(color: Colors.amber.shade900),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Post'),
        content: TextField(
          controller: textController,
          autofocus: true,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Share your thoughts...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post cannot be empty')),
                );
                return;
              }

              context.read<CommunityBloc>().add(
                    CreateForumPost(
                      threadId: widget.threadId,
                      content: textController.text,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
