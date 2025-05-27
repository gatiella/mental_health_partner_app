// lib/presentation/pages/community/challenge_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/domain/entities/community_challenge.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';

class ChallengeDetailPage extends StatelessWidget {
  final CommunityChallenge challenge;

  const ChallengeDetailPage({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(challenge.title),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressSection(context),
            const SizedBox(height: 24),
            Text(
              challenge.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),
            _buildParticipantsSection(context),
            const SizedBox(height: 24),
            _buildTimelineSection(context),
          ],
        ),
      ),
      floatingActionButton: challenge.isParticipating
          ? FloatingActionButton.extended(
              onPressed: () => context.read<CommunityBloc>().add(
                    CompleteChallenge(challengeId: challenge.id),
                  ),
              icon: const Icon(Icons.check),
              label: const Text('Mark Complete'),
            )
          : FloatingActionButton.extended(
              onPressed: () => context.read<CommunityBloc>().add(
                    JoinChallenge(challengeId: challenge.id),
                  ),
              icon: const Icon(Icons.group_add),
              label: const Text('Join Challenge'),
            ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return LinearProgressIndicator(
      value: challenge.participantCount / 100, // Adjust based on your logic
      backgroundColor: AppColors.backgroundLight,
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      minHeight: 12,
      borderRadius: BorderRadius.circular(6),
    );
  }

  Widget _buildParticipantsSection(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.people_outline, size: 24),
        const SizedBox(width: 8),
        Text('${challenge.participantCount} Participants',
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildTimelineSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Challenge Timeline',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text('Start Date: ${_formatDate(challenge.startDate)}'),
        ),
        ListTile(
          leading: const Icon(Icons.flag),
          title: Text('End Date: ${_formatDate(challenge.endDate)}'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
