import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/exceptions.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/network/network_info.dart';
import 'package:mental_health_partner/data/datasources/local/community_local_data_source.dart';
import 'package:mental_health_partner/data/datasources/remote/community_remote_data_source.dart';
import 'package:mental_health_partner/domain/entities/community_challenge.dart';
import 'package:mental_health_partner/domain/entities/community_engagement.dart';
import 'package:mental_health_partner/domain/entities/discussion_group.dart';
import 'package:mental_health_partner/domain/entities/forum_post.dart';
import 'package:mental_health_partner/domain/entities/forum_thread.dart';
import 'package:mental_health_partner/domain/entities/success_story.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;
  final CommunityLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CommunityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // Discussion Groups
  @override
  Future<Either<Failure, List<DiscussionGroup>>> getDiscussionGroups(
      {String? topic}) async {
    if (await networkInfo.isConnected) {
      try {
        final groups = await remoteDataSource.getDiscussionGroups(topic: topic);
        await localDataSource.cacheDiscussionGroups(groups);
        return Right(groups);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final localGroups = await localDataSource.getCachedDiscussionGroups();
        return Right(localGroups);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> joinDiscussionGroup(String groupSlug,
      {bool isAnonymous = false}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.joinDiscussionGroup(groupSlug,
          isAnonymous: isAnonymous);
      localDataSource.clearCache();
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> leaveDiscussionGroup(String groupSlug) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.leaveDiscussionGroup(groupSlug);
      localDataSource.clearCache();
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // Forum Threads
  @override
  Future<Either<Failure, List<ForumThread>>> getForumThreads(
      {String? groupId}) async {
    if (await networkInfo.isConnected) {
      try {
        final threads =
            await remoteDataSource.getForumThreads(groupId: groupId);
        await localDataSource.cacheForumThreads(threads);
        return Right(threads);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final localThreads = await localDataSource.getCachedForumThreads();
        return Right(localThreads);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, ForumThread>> getThreadDetails(String threadId) async {
    if (await networkInfo.isConnected) {
      try {
        final thread = await remoteDataSource.getThreadDetails(threadId);
        return Right(thread);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ForumThread>> createForumThread(
      String title, String groupId,
      {bool isAnonymous = false}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final thread = await remoteDataSource.createForumThread(title, groupId,
          isAnonymous: isAnonymous);
      localDataSource.clearCache();
      return Right(thread);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // Forum Posts
  @override
  Future<Either<Failure, List<ForumPost>>> getForumPosts(
      String threadId) async {
    if (await networkInfo.isConnected) {
      try {
        final posts = await remoteDataSource.getForumPosts(threadId);
        return Right(posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleEncouragement(String postId,
      {String type = 'support'}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.toggleEncouragement(postId, type: type);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CommunityEngagement>> getCommunityEngagement() async {
    if (await networkInfo.isConnected) {
      try {
        final discussions = await remoteDataSource.getDiscussionGroups();
        final challenges = await remoteDataSource.getChallenges();
        final threads = await remoteDataSource.getForumThreads();
        final stories = await remoteDataSource.getSuccessStories();

        // Cache the data
        await localDataSource.cacheDiscussionGroups(discussions);
        await localDataSource.cacheChallenges(challenges);
        await localDataSource.cacheForumThreads(threads);
        await localDataSource.cacheSuccessStories(stories);

        return Right(CommunityEngagement(
          activeDiscussions: discussions.length,
          challengesCompleted: challenges.where((c) => c.isActive).length,
          forumPosts: threads.fold(0, (sum, thread) => sum + thread.postCount),
          successStories: stories.length,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final discussions = await localDataSource.getCachedDiscussionGroups();
        final challenges = await localDataSource.getCachedChallenges();
        final threads = await localDataSource.getCachedForumThreads();
        final stories = await localDataSource.getCachedSuccessStories();

        return Right(CommunityEngagement(
          activeDiscussions: discussions.length,
          challengesCompleted: challenges.where((c) => c.isActive).length,
          forumPosts: threads.fold(0, (sum, thread) => sum + thread.postCount),
          successStories: stories.length,
        ));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  // Challenges
  @override
  Future<Either<Failure, List<CommunityChallenge>>> getChallenges(
      {String? type}) async {
    if (await networkInfo.isConnected) {
      try {
        final challenges = await remoteDataSource.getChallenges(type: type);
        await localDataSource.cacheChallenges(challenges);
        return Right(challenges);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final localChallenges = await localDataSource.getCachedChallenges();
        return Right(localChallenges);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> joinChallenge(String challengeId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.joinChallenge(challengeId);
      localDataSource.clearCache();
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> completeChallenge(String challengeId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.completeChallenge(challengeId);
      localDataSource.clearCache();
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // Success Stories
  @override
  Future<Either<Failure, List<SuccessStory>>> getSuccessStories(
      {String? category}) async {
    if (await networkInfo.isConnected) {
      try {
        final stories =
            await remoteDataSource.getSuccessStories(category: category);
        await localDataSource.cacheSuccessStories(stories);
        return Right(stories);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final localStories = await localDataSource.getCachedSuccessStories();
        return Right(localStories);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, SuccessStory>> createSuccessStory(
    String title,
    String content,
    String category, {
    bool isAnonymous = false,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final story = await remoteDataSource.createSuccessStory(
          title, content, category,
          isAnonymous: isAnonymous);
      localDataSource.clearCache();
      return Right(story);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleStoryEncouragement(String storyId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.toggleStoryEncouragement(storyId);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ForumPost>> createForumPost(
    String threadId,
    String content, {
    bool isAnonymous = false,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      // Correct parameter passing
      final post = await remoteDataSource.createForumPost(
        threadId, // Positional parameter
        content, // Positional parameter
        isAnonymous: isAnonymous, // Named parameter
      );
      localDataSource.clearCache();
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

// In CommunityRepositoryImpl
  @override
  Future<Either<Failure, ForumThread>> getForumThreadDetails(
      String threadId) async {
    if (await networkInfo.isConnected) {
      try {
        final thread = await remoteDataSource.getForumThreadDetails(threadId);
        await localDataSource.cacheForumThreads([thread]);
        return Right(thread);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final cachedThreads = await localDataSource.getCachedForumThreads();
        final thread = cachedThreads.firstWhere(
          (t) => t.id == threadId,
          orElse: () => throw CacheException(message: 'Thread not cached'),
        );
        return Right(thread);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }
}
