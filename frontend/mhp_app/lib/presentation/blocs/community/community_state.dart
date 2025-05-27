// lib/presentation/blocs/community/community_state.dart

import 'package:flutter/material.dart';
import 'package:mental_health_partner/domain/entities/community_challenge.dart';
import 'package:mental_health_partner/domain/entities/discussion_group.dart';
import 'package:mental_health_partner/domain/entities/forum_post.dart';
import 'package:mental_health_partner/domain/entities/forum_thread.dart';
import 'package:mental_health_partner/domain/entities/success_story.dart';

@immutable
sealed class CommunityState {}

final class CommunityInitial extends CommunityState {}

final class CommunityLoading extends CommunityState {}

final class CommunityError extends CommunityState {
  final String message;

  CommunityError(this.message);
}

// Discussion Groups States
final class DiscussionGroupsLoaded extends CommunityState {
  final List<DiscussionGroup> groups;

  DiscussionGroupsLoaded(this.groups);
}

// Forum States
final class ForumThreadsLoaded extends CommunityState {
  final List<ForumThread> threads;

  ForumThreadsLoaded(this.threads);
}

class ThreadDetailsLoaded extends CommunityState {
  final ForumThread thread;

  ThreadDetailsLoaded(this.thread);
}

class ForumPostsLoaded extends CommunityState {
  final List<ForumPost> posts;
  final bool isThreadLocked;

  ForumPostsLoaded(this.posts, {this.isThreadLocked = false});

  List<Object?> get props => [posts, isThreadLocked];
}

final class ForumPostCreated extends CommunityState {
  final ForumPost post;

  ForumPostCreated(this.post);
}

// Challenges States
final class ChallengesLoaded extends CommunityState {
  final List<CommunityChallenge> challenges;

  ChallengesLoaded(this.challenges);
}

final class ChallengeUpdated extends CommunityState {
  final CommunityChallenge challenge;

  ChallengeUpdated(this.challenge);
}

// Success Stories States
final class SuccessStoriesLoaded extends CommunityState {
  final List<SuccessStory> stories;

  SuccessStoriesLoaded(this.stories);
}

final class SuccessStoryCreated extends CommunityState {
  final SuccessStory story;

  SuccessStoryCreated(this.story);
}

// Encouragement States
final class EncouragementToggled extends CommunityState {
  final String postId;
  final bool isEncouraged;

  EncouragementToggled(this.postId, this.isEncouraged);
}

final class StoryEncouragementToggled extends CommunityState {
  final String storyId;
  final bool isEncouraged;

  StoryEncouragementToggled(this.storyId, this.isEncouraged);
}
