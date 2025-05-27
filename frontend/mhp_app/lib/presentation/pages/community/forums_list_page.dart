// lib/presentation/pages/community/forums_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_state.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/pages/community/forum_thread_detail_page.dart';
import 'package:mental_health_partner/presentation/widgets/community/forum_thread_card.dart';

class ForumsListPage extends StatefulWidget {
  const ForumsListPage({super.key});

  @override
  State<ForumsListPage> createState() => _ForumsListPageState();
}

class _ForumsListPageState extends State<ForumsListPage> {
  @override
  void initState() {
    super.initState();
    // Load forum threads when page loads
    context.read<CommunityBloc>().add(LoadForumThreads());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Forum'),
        elevation: 4,
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state is CommunityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ForumThreadsLoaded) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                    itemCount: state.threads.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final thread = state.threads[index];
                      return ForumThreadCard(
                        thread: thread,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<CommunityBloc>(),
                              child: ForumThreadDetailPage(
                                threadId: thread.id,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is CommunityError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
