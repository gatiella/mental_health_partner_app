import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/di/injection_container.dart';
import 'package:mental_health_partner/presentation/blocs/analytics/analytics_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/analytics/analytics_event.dart';
import 'package:mental_health_partner/presentation/blocs/analytics/analytics_state.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';
import 'package:mental_health_partner/presentation/widgets/analytics/activity_summary.dart';
import 'package:mental_health_partner/presentation/widgets/mood/mood_chart.dart';

class AnalyticsDashboard extends StatelessWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) {
        final bloc = sl<AnalyticsBloc>();
        bloc.add(LoadMoodAnalytics());
        bloc.add(LoadUserActivity());
        bloc.add(LoadCommunityEngagement()); // Add this event
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Wellness Analytics"),
          elevation: 0,
          backgroundColor:
              isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
          foregroundColor: isDark ? AppColors.textPrimaryDark : Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      AppColors.primaryDarkColor.withOpacity(0.1),
                      AppColors.backgroundDark,
                    ]
                  : [
                      AppColors.primaryLightColor.withOpacity(0.1),
                      AppColors.backgroundLight,
                    ],
            ),
          ),
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              final bloc = BlocProvider.of<AnalyticsBloc>(context);
              bloc.add(LoadMoodAnalytics());
              bloc.add(LoadUserActivity());
              bloc.add(LoadCommunityEngagement()); // Add this refresh
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, "Your Wellness Journey"),
                  const SizedBox(height: 16),
                  _buildCard(
                    context,
                    title: "Mood Patterns",
                    icon: Icons.mood,
                    iconColor: AppColors.moodHappy,
                    content: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                      buildWhen: (previous, current) =>
                          current is MoodAnalyticsLoaded ||
                          (current is AnalyticsLoading &&
                              previous is! MoodAnalyticsLoaded),
                      builder: (context, state) {
                        if (state is MoodAnalyticsLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your mood patterns over time",
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 220,
                                child:
                                    MoodChart(analyticsData: state.analytics),
                              ),
                            ],
                          );
                        }
                        if (state is AnalyticsError) {
                          return _buildErrorWidget(state.message);
                        }
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    context,
                    title: "Activity Overview",
                    icon: Icons.bar_chart_rounded,
                    iconColor: AppColors.secondaryColor,
                    content: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                      buildWhen: (previous, current) =>
                          current is UserActivityLoaded ||
                          (current is AnalyticsLoading &&
                              previous is! UserActivityLoaded),
                      builder: (context, state) {
                        if (state is UserActivityLoaded) {
                          return ActivitySummary(activity: state.activity);
                        }
                        if (state is AnalyticsError) {
                          return _buildErrorWidget(state.message);
                        }
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Updated Community Engagement Card with BlocBuilder
                  _buildCard(
                    context,
                    title: "Community Engagement",
                    icon: Icons.people,
                    iconColor: AppColors.secondaryColor,
                    content: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                      buildWhen: (previous, current) =>
                          current is CommunityEngagementLoaded ||
                          (current is AnalyticsLoading &&
                              previous is! CommunityEngagementLoaded),
                      builder: (context, state) {
                        if (state is CommunityEngagementLoaded) {
                          return Column(
                            children: [
                              _buildCommunityMetric(
                                context,
                                "Active Discussions",
                                "${state.activeDiscussions}",
                                state.activeDiscussions > 0
                                    ? _getNewDiscussionsText(
                                        state.activeDiscussions)
                                    : "No new discussions",
                              ),
                              _buildCommunityMetric(
                                context,
                                "Challenges Completed",
                                "${state.challengesCompleted}",
                                _getChallengeCompletionText(
                                    state.challengesCompleted),
                              ),
                              _buildCommunityMetric(
                                context,
                                "Forum Posts",
                                "${state.forumPosts}",
                                state.forumPosts > 0
                                    ? _getNewPostsText(state.forumPosts)
                                    : "No new posts",
                              ),
                              _buildCommunityMetric(
                                context,
                                "Success Stories",
                                "${state.successStories}",
                                state.successStories > 0
                                    ? _getNewStoriesText(state.successStories)
                                    : "No new stories",
                              ),
                            ],
                          );
                        }
                        if (state is AnalyticsError) {
                          return _buildErrorWidget(state.message);
                        }
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    context,
                    title: "Wellness Insights",
                    icon: Icons.lightbulb_outline,
                    iconColor: AppColors.moodCalm,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTip(
                          context,
                          "Regular check-ins help track your emotional well-being",
                          Icons.check_circle_outline,
                          AppColors.successColor,
                        ),
                        const SizedBox(height: 12),
                        _buildTip(
                          context,
                          "Journaling helps process emotions more effectively",
                          Icons.edit_note,
                          AppColors.breathworkHighlight,
                        ),
                        const SizedBox(height: 12),
                        _buildTip(
                          context,
                          "Conversations with your mental health partner build resilience",
                          Icons.chat_bubble_outline,
                          AppColors.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for generating dynamic descriptions
  String _getNewDiscussionsText(int count) {
    if (count == 1) return "1 active discussion";
    if (count <= 5) return "$count discussions active";
    return "$count active discussions";
  }

  String _getChallengeCompletionText(int completed) {
    if (completed == 0) return "Start your first challenge";
    if (completed == 1) return "1 challenge completed";
    if (completed <= 10) return "$completed challenges done";
    return "$completed challenges completed!";
  }

  String _getNewPostsText(int count) {
    if (count <= 5) return "$count recent posts";
    if (count <= 20) return "$count posts this week";
    return "$count total posts";
  }

  String _getNewStoriesText(int count) {
    if (count == 1) return "1 inspiring story";
    if (count <= 5) return "$count inspiring stories";
    return "$count success stories shared";
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget content,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.textSecondaryDark.withOpacity(0.2)
                        : const Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(
      BuildContext context, String text, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.errorColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error: $message',
              style: const TextStyle(
                color: AppColors.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityMetric(
      BuildContext context, String title, String value, String description) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
