import 'package:equatable/equatable.dart';
import 'package:mental_health_partner/data/models/analytics_model.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class MoodAnalyticsLoaded extends AnalyticsState {
  final Map<String, dynamic> analytics;

  const MoodAnalyticsLoaded(this.analytics);

  @override
  List<Object> get props => [analytics];
}

class UserActivityLoaded extends AnalyticsState {
  final UserActivity activity; // Changed to UserActivity type

  const UserActivityLoaded(this.activity);

  @override
  List<Object> get props => [activity];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object> get props => [message];
}

class CommunityEngagementLoaded extends AnalyticsState {
  final int activeDiscussions;
  final int challengesCompleted;
  final int forumPosts;
  final int successStories;

  const CommunityEngagementLoaded({
    required this.activeDiscussions,
    required this.challengesCompleted,
    required this.forumPosts,
    required this.successStories,
  });

  @override
  List<Object> get props => [
        activeDiscussions,
        challengesCompleted,
        forumPosts,
        successStories,
      ];
}
