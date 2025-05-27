import 'package:flutter/material.dart';
import 'package:mental_health_partner/data/models/analytics_model.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';

class ActivitySummary extends StatelessWidget {
  final UserActivity activity;

  const ActivitySummary({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Here's a summary of your wellness activities",
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child: _buildMetricCard(
              context,
              count: activity.conversationsCount,
              label: "Conversations",
              icon: Icons.chat_bubble_outline,
              color: AppColors.primaryColor,
            )),
            const SizedBox(width: 12),
            Expanded(
                child: _buildMetricCard(
              context,
              count: activity.messagesCount,
              label: "Messages",
              icon: Icons.message_outlined,
              color: AppColors.secondaryColor,
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildMetricCard(
              context,
              count: activity.journalsCount,
              label: "Journal Entries",
              icon: Icons.book_outlined,
              color: AppColors.meditationAccent,
            )),
            const SizedBox(width: 12),
            Expanded(
                child: _buildMetricCard(
              context,
              count: activity.moodsCount,
              label: "Mood Entries",
              icon: Icons.emoji_emotions_outlined,
              color: AppColors.moodHappy,
            )),
          ],
        ),
        const SizedBox(height: 20),
        _buildTimeMetric(context),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required int count,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimaryLight.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeMetric(BuildContext context) {
    // Calculate percentage based on a target of 10 hours per month
    const targetMinutes = 600.0; // 10 hours
    final percentComplete =
        (activity.conversationMinutes / targetMinutes * 100).clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.breathworkHighlight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.breathworkHighlight,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Conversation Time",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.breathworkHighlight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${activity.conversationMinutes.toStringAsFixed(1)} min",
                  style: const TextStyle(
                    color: AppColors.breathworkHighlight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentComplete / 100,
              backgroundColor: Colors.grey.withOpacity(0.1),
              color: AppColors.breathworkHighlight,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${percentComplete.toStringAsFixed(1)}% of monthly goal",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
