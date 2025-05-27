// lib/domain/repositories/community_repository.dart

import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/domain/entities/community_engagement.dart';
import '../../core/errors/failure.dart';
import '../entities/community_challenge.dart';
import '../entities/discussion_group.dart';
import '../entities/forum_post.dart';
import '../entities/forum_thread.dart';
import '../entities/success_story.dart';

abstract class CommunityRepository {
  // Discussion Groups
  Future<Either<Failure, List<DiscussionGroup>>> getDiscussionGroups(
      {String? topic});
  Future<Either<Failure, bool>> joinDiscussionGroup(String groupId,
      {bool isAnonymous = false});
  Future<Either<Failure, bool>> leaveDiscussionGroup(String groupId);
  Future<Either<Failure, CommunityEngagement>> getCommunityEngagement();
  // Forum Threads
  Future<Either<Failure, List<ForumThread>>> getForumThreads({String? groupId});
  Future<Either<Failure, ForumThread>> getForumThreadDetails(String threadId);
  Future<Either<Failure, ForumThread>> createForumThread(
      String title, String groupId,
      {bool isAnonymous = false});

  // Forum Posts
  Future<Either<Failure, List<ForumPost>>> getForumPosts(String threadId);
  Future<Either<Failure, ForumPost>> createForumPost(
      String threadId, String content,
      {bool isAnonymous = false});
  Future<Either<Failure, bool>> toggleEncouragement(String postId,
      {String type = 'support'});

  // Community Challenges
  Future<Either<Failure, List<CommunityChallenge>>> getChallenges(
      {String? type});
  Future<Either<Failure, bool>> joinChallenge(String challengeId);
  Future<Either<Failure, bool>> completeChallenge(String challengeId);

  // Success Stories
  Future<Either<Failure, List<SuccessStory>>> getSuccessStories(
      {String? category});
  Future<Either<Failure, SuccessStory>> createSuccessStory(
      String title, String content, String category,
      {bool isAnonymous = false});
  Future<Either<Failure, bool>> toggleStoryEncouragement(String storyId);
  Future<Either<Failure, ForumThread>> getThreadDetails(String threadId);
}
