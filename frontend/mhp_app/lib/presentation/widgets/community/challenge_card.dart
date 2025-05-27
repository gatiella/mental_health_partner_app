// lib/presentation/widgets/community/challenge_card.dart
import 'package:flutter/material.dart';
import 'package:mental_health_partner/domain/entities/community_challenge.dart';
import '../../themes/app_colors.dart';

class ChallengeCard extends StatelessWidget {
  final CommunityChallenge challenge;
  final VoidCallback onJoin;
  final VoidCallback onComplete;
  final VoidCallback? onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onJoin,
    required this.onComplete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final daysLeft = challenge.endDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      challenge.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildParticipationStatus(context),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                challenge.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              _buildProgressIndicator(context),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateChip(
                    context,
                    icon: Icons.calendar_today,
                    text: '${daysLeft}d left',
                  ),
                  _buildChallengeButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipationStatus(BuildContext context) {
    final isActive = challenge.isActive && !challenge.isParticipating;
    return Chip(
      backgroundColor: isActive
          ? AppColors.successLightColor.withOpacity(0.2)
          : AppColors.secondaryLightColor.withOpacity(0.1),
      label: Text(
        challenge.isParticipating ? 'Joined' : 'New',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive
                  ? AppColors.successColor
                  : AppColors.textSecondaryLight,
            ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return LinearProgressIndicator(
      value: challenge.participantCount / 100,
      backgroundColor: AppColors.backgroundLight,
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      borderRadius: BorderRadius.circular(4),
    );
  }

  Widget _buildDateChip(BuildContext context,
      {required IconData icon, required String text}) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildChallengeButton(BuildContext context) {
    return challenge.isParticipating
        ? OutlinedButton(
            onPressed: onComplete,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              side: const BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Complete'),
          )
        : ElevatedButton(
            onPressed: onJoin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Join Challenge'),
          );
  }
}
