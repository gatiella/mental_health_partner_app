// lib/presentation/blocs/community/community_event.dart
import 'package:flutter/material.dart';

@immutable
sealed class CommunityEvent {}

// Discussion Groups Events
final class LoadDiscussionGroups extends CommunityEvent {
  final String? topic;

  LoadDiscussionGroups({this.topic});
}

class JoinGroup extends CommunityEvent {
  final String groupSlug; // Changed from groupId to groupSlug
  final bool isAnonymous;
  final String? topic;

  JoinGroup(this.groupSlug, {this.isAnonymous = false, this.topic});

  List<Object?> get props => [groupSlug, isAnonymous, topic];
}

final class LeaveGroup extends CommunityEvent {
  final String groupId;
  final String? topic;

  LeaveGroup({required this.groupId, this.topic});
}

// Forum Events
final class LoadForumThreads extends CommunityEvent {
  final String? groupId;

  LoadForumThreads({this.groupId});
}

final class CreateForumThread extends CommunityEvent {
  final String title;
  final String groupId;
  final bool isAnonymous;

  CreateForumThread({
    required this.title,
    required this.groupId,
    this.isAnonymous = false,
  });
}

final class LoadForumPosts extends CommunityEvent {
  final String threadId;

  LoadForumPosts({required this.threadId});
}

final class CreateForumPost extends CommunityEvent {
  final String threadId;
  final String content;
  final bool isAnonymous;

  CreateForumPost({
    required this.threadId,
    required this.content,
    this.isAnonymous = false,
  });
}

// Challenges Events
final class LoadChallenges extends CommunityEvent {
  final String? type;

  LoadChallenges({this.type});
}

final class JoinChallenge extends CommunityEvent {
  final String challengeId;

  JoinChallenge({required this.challengeId});
}

final class CompleteChallenge extends CommunityEvent {
  final String challengeId;

  CompleteChallenge({required this.challengeId});
}

// Success Stories Events
final class LoadSuccessStories extends CommunityEvent {
  final String? category;

  LoadSuccessStories({this.category});
}

final class CreateSuccessStory extends CommunityEvent {
  final String title;
  final String content;
  final String category;
  final bool isAnonymous;

  CreateSuccessStory({
    required this.title,
    required this.content,
    required this.category,
    this.isAnonymous = false,
  });
}

class GetThreadDetails extends CommunityEvent {
  final String threadId;

  GetThreadDetails({required this.threadId});
}

// Encouragement Events
final class ToggleEncouragement extends CommunityEvent {
  final String postId;
  final String type;

  ToggleEncouragement({required this.postId, this.type = 'support'});
}

final class ToggleStoryEncouragement extends CommunityEvent {
  final String storyId;

  ToggleStoryEncouragement({required this.storyId});
}
