// lib/presentation/pages/community/discussion_groups_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_state.dart';
import 'package:mental_health_partner/presentation/widgets/community/discussion_group_card.dart';
import 'package:mental_health_partner/presentation/pages/community/discussion_group_page.dart';

class DiscussionGroupsListPage extends StatelessWidget {
  const DiscussionGroupsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Groups'),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state is CommunityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DiscussionGroupsLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.groups.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final group = state.groups[index];
                return DiscussionGroupCard(
                  group: group,
                  onJoin: () => context.read<CommunityBloc>().add(
                        JoinGroup(
                          group.slug,
                          topic: group.topicType,
                        ),
                      ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DiscussionGroupPage(groupSlug: group.slug),
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Groups'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Anxiety'),
              onTap: () => context
                  .read<CommunityBloc>()
                  .add(LoadDiscussionGroups(topic: 'anxiety')),
            ),
            ListTile(
              title: const Text('Depression'),
              onTap: () => context
                  .read<CommunityBloc>()
                  .add(LoadDiscussionGroups(topic: 'depression')),
            ),
          ],
        ),
      ),
    );
  }
}
