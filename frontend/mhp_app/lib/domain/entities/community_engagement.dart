import 'package:equatable/equatable.dart';

class CommunityEngagement extends Equatable {
  final int activeDiscussions;
  final int challengesCompleted;
  final int forumPosts;
  final int successStories;

  const CommunityEngagement({
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

  CommunityEngagement copyWith({
    int? activeDiscussions,
    int? challengesCompleted,
    int? forumPosts,
    int? successStories,
  }) {
    return CommunityEngagement(
      activeDiscussions: activeDiscussions ?? this.activeDiscussions,
      challengesCompleted: challengesCompleted ?? this.challengesCompleted,
      forumPosts: forumPosts ?? this.forumPosts,
      successStories: successStories ?? this.successStories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeDiscussions': activeDiscussions,
      'challengesCompleted': challengesCompleted,
      'forumPosts': forumPosts,
      'successStories': successStories,
    };
  }

  factory CommunityEngagement.fromJson(Map<String, dynamic> json) {
    return CommunityEngagement(
      activeDiscussions: json['activeDiscussions'] ?? 0,
      challengesCompleted: json['challengesCompleted'] ?? 0,
      forumPosts: json['forumPosts'] ?? 0,
      successStories: json['successStories'] ?? 0,
    );
  }
}
