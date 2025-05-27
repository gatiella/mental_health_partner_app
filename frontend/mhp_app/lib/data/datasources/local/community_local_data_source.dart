// lib/data/datasources/local/community_local_data_source.dart
import 'package:mental_health_partner/core/storage/local_storage.dart';
import 'package:mental_health_partner/data/models/discussion_group_model.dart';
import 'package:mental_health_partner/data/models/forum_thread_model.dart';
import 'package:mental_health_partner/data/models/community_challenge_model.dart';
import 'package:mental_health_partner/data/models/success_story_model.dart';

abstract class CommunityLocalDataSource {
  Future<List<DiscussionGroupModel>> getCachedDiscussionGroups();
  Future<void> cacheDiscussionGroups(List<DiscussionGroupModel> groups);

  Future<List<ForumThreadModel>> getCachedForumThreads();
  Future<void> cacheForumThreads(List<ForumThreadModel> threads);

  Future<List<CommunityChallengeModel>> getCachedChallenges();
  Future<void> cacheChallenges(List<CommunityChallengeModel> challenges);

  Future<List<SuccessStoryModel>> getCachedSuccessStories();
  Future<void> cacheSuccessStories(List<SuccessStoryModel> stories);

  Future<void> clearCache();
}

class CommunityLocalDataSourceImpl implements CommunityLocalDataSource {
  final LocalStorage localStorage;

  static const String DISCUSSION_GROUPS_KEY = 'discussion_groups';
  static const String FORUM_THREADS_KEY = 'forum_threads';
  static const String CHALLENGES_KEY = 'challenges';
  static const String SUCCESS_STORIES_KEY = 'success_stories';

  CommunityLocalDataSourceImpl({required this.localStorage});

  @override
  Future<List<DiscussionGroupModel>> getCachedDiscussionGroups() async {
    final cached = localStorage.getObject(DISCUSSION_GROUPS_KEY);
    if (cached != null) {
      return (cached['entries'] as List)
          .map((json) => DiscussionGroupModel.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheDiscussionGroups(List<DiscussionGroupModel> groups) async {
    final cached =
        localStorage.getObject(DISCUSSION_GROUPS_KEY) ?? {'entries': []};
    cached['entries'] = groups.map((group) => group.toJson()).toList();
    await localStorage.setObject(DISCUSSION_GROUPS_KEY, cached);
  }

  @override
  Future<List<ForumThreadModel>> getCachedForumThreads() async {
    final cached = localStorage.getObject(FORUM_THREADS_KEY);
    if (cached != null) {
      return (cached['entries'] as List)
          .map((json) => ForumThreadModel.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheForumThreads(List<ForumThreadModel> threads) async {
    final cached = localStorage.getObject(FORUM_THREADS_KEY) ?? {'entries': []};
    cached['entries'] = threads.map((thread) => thread.toJson()).toList();
    await localStorage.setObject(FORUM_THREADS_KEY, cached);
  }

  @override
  Future<List<CommunityChallengeModel>> getCachedChallenges() async {
    final cached = localStorage.getObject(CHALLENGES_KEY);
    if (cached != null) {
      return (cached['entries'] as List)
          .map((json) => CommunityChallengeModel.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheChallenges(List<CommunityChallengeModel> challenges) async {
    final cached = localStorage.getObject(CHALLENGES_KEY) ?? {'entries': []};
    cached['entries'] =
        challenges.map((challenge) => challenge.toJson()).toList();
    await localStorage.setObject(CHALLENGES_KEY, cached);
  }

  @override
  Future<List<SuccessStoryModel>> getCachedSuccessStories() async {
    final cached = localStorage.getObject(SUCCESS_STORIES_KEY);
    if (cached != null) {
      return (cached['entries'] as List)
          .map((json) => SuccessStoryModel.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheSuccessStories(List<SuccessStoryModel> stories) async {
    final cached =
        localStorage.getObject(SUCCESS_STORIES_KEY) ?? {'entries': []};
    cached['entries'] = stories.map((story) => story.toJson()).toList();
    await localStorage.setObject(SUCCESS_STORIES_KEY, cached);
  }

  @override
  Future<void> clearCache() async {
    await localStorage.remove(DISCUSSION_GROUPS_KEY);
    await localStorage.remove(FORUM_THREADS_KEY);
    await localStorage.remove(CHALLENGES_KEY);
    await localStorage.remove(SUCCESS_STORIES_KEY);
  }
}
