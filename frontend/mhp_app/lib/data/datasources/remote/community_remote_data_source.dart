import 'package:dio/dio.dart';
import 'package:mental_health_partner/core/errors/exceptions.dart';
import 'package:mental_health_partner/data/models/discussion_group_model.dart';
import 'package:mental_health_partner/data/models/forum_thread_model.dart';
import 'package:mental_health_partner/data/models/forum_post_model.dart';
import 'package:mental_health_partner/data/models/community_challenge_model.dart';
import 'package:mental_health_partner/data/models/success_story_model.dart';
import 'package:mental_health_partner/core/network/api_client.dart';

abstract class CommunityRemoteDataSource {
  Future<List<DiscussionGroupModel>> getDiscussionGroups({String? topic});
  Future<void> joinDiscussionGroup(String groupId, {bool isAnonymous});
  Future<void> leaveDiscussionGroup(String groupId);

  Future<List<ForumThreadModel>> getForumThreads({String? groupId});
  Future<ForumThreadModel> createForumThread(String title, String groupId,
      {bool isAnonymous});

  Future<ForumThreadModel> getForumThreadDetails(String threadId);

  Future<List<ForumPostModel>> getForumPosts(String threadId);
  Future<ForumPostModel> createForumPost(
    String threadId,
    String content, {
    bool isAnonymous = false,
  });
  Future<void> toggleEncouragement(String postId, {String type});

  Future<List<CommunityChallengeModel>> getChallenges({String? type});
  Future<void> joinChallenge(String challengeId);
  Future<void> completeChallenge(String challengeId);

  Future<List<SuccessStoryModel>> getSuccessStories({String? category});
  Future<SuccessStoryModel> createSuccessStory(
      String title, String content, String category,
      {bool isAnonymous});
  Future<void> toggleStoryEncouragement(String storyId);
  Future<ForumThreadModel> getThreadDetails(String threadId);
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final ApiClient client;

  CommunityRemoteDataSourceImpl({required this.client});

  @override
  Future<List<DiscussionGroupModel>> getDiscussionGroups(
      {String? topic}) async {
    final response = await client.get(
      'api/community/discussion-groups/',
      queryParameters: topic != null ? {'topic': topic} : null,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        // Handle paginated response
        return (data['results'] as List)
            .map((json) => DiscussionGroupModel.fromJson(json))
            .toList();
      } else if (data is List) {
        // Handle direct list response
        return data.map((json) => DiscussionGroupModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Unexpected response format');
      }
    } else {
      throw ServerException(message: 'Failed to load discussion groups');
    }
  }

  @override
  Future<void> joinDiscussionGroup(String groupSlug,
      {bool isAnonymous = false}) async {
    final response = await client.post(
      'api/community/discussion-groups/$groupSlug/join/',
      data: {'is_anonymous': isAnonymous},
    );

    if (response.statusCode != 201) {
      throw ServerException(message: 'Failed to join discussion group');
    }
  }

  @override
  Future<void> leaveDiscussionGroup(String groupSlug) async {
    final response = await client.post(
      'api/community/discussion-groups/$groupSlug/leave/',
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to leave discussion group');
    }
  }

  @override
  Future<List<ForumThreadModel>> getForumThreads({String? groupId}) async {
    final response = await client.get(
      'api/community/forum-threads/',
      queryParameters: groupId != null ? {'group': groupId} : null,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        // Handle paginated response
        return (data['results'] as List)
            .map((json) => ForumThreadModel.fromJson(json))
            .toList();
      } else if (data is List) {
        // Handle direct list response
        return data.map((json) => ForumThreadModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Unexpected response format');
      }
    } else {
      throw ServerException(message: 'Failed to load forum threads');
    }
  }

  @override
  Future<ForumThreadModel> getForumThreadDetails(String threadId) async {
    final response = await client.get(
      'api/community/forum-threads/$threadId/',
    );

    if (response.statusCode == 200) {
      return ForumThreadModel.fromJson(response.data);
    } else if (response.statusCode == 404) {
      throw ServerException(message: 'Thread not found');
    } else {
      throw ServerException(message: 'Failed to load thread details');
    }
  }

  @override
  Future<ForumThreadModel> createForumThread(String title, String groupId,
      {bool isAnonymous = false}) async {
    final response = await client.post(
      'api/community/forum-threads/',
      data: {
        'title': title,
        'discussion_group': groupId,
        'is_anonymous': isAnonymous,
      },
    );

    if (response.statusCode == 201) {
      return ForumThreadModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Failed to create forum thread');
    }
  }

  @override
  Future<List<ForumPostModel>> getForumPosts(String threadId) async {
    final response = await client.get(
      'api/community/forum-posts/',
      queryParameters: {'thread': threadId},
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        // Handle paginated response
        return (data['results'] as List)
            .map((json) => ForumPostModel.fromJson(json))
            .toList();
      } else if (data is List) {
        // Handle direct list response
        return data.map((json) => ForumPostModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Unexpected response format');
      }
    } else {
      throw ServerException(message: 'Failed to load forum posts');
    }
  }

  @override
  Future<ForumPostModel> createForumPost(
    String threadId,
    String content, {
    bool isAnonymous = false,
  }) async {
    try {
      final response = await client.post(
        'api/community/forum-posts/',
        data: {
          'thread': threadId,
          'content': content,
          'is_anonymous': isAnonymous,
        },
      );

      if (response.statusCode == 201) {
        return ForumPostModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Failed to create forum post');
      }
    } on DioException catch (e) {
      // Check specifically for locked thread error
      if (e.response?.statusCode == 403 &&
          e.response?.data is Map &&
          e.response?.data['detail'] == 'This thread is locked.') {
        throw ServerException(
            message: 'This thread is locked and cannot receive new posts');
      } else {
        // Handle other DioException cases
        final message = e.response?.data is Map
            ? e.response?.data['detail'] ?? 'Failed to create forum post'
            : 'Failed to create forum post';
        throw ServerException(message: message);
      }
    } catch (e) {
      // Handle any other exceptions
      throw ServerException(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<ForumThreadModel> getThreadDetails(String threadId) async {
    final response = await client.get('api/community/forum-threads/$threadId/');

    if (response.statusCode == 200) {
      return ForumThreadModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Failed to get thread details');
    }
  }

  @override
  Future<void> toggleEncouragement(String postId,
      {String type = 'support'}) async {
    final response = await client.post(
      'api/community/encouragements/toggle/',
      data: {
        'post': postId,
        'encouragement_type': type,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(message: 'Failed to toggle encouragement');
    }
  }

  @override
  Future<List<CommunityChallengeModel>> getChallenges({String? type}) async {
    final queryParams = <String, dynamic>{};
    if (type != null) {
      queryParams['type'] = type;
    }
    // Add no_pagination parameter to get all results if possible
    queryParams['no_pagination'] = true;

    final response = await client.get(
      'api/community/challenges/',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        // Handle paginated response
        return (data['results'] as List)
            .map((json) => CommunityChallengeModel.fromJson(json))
            .toList();
      } else if (data is List) {
        // Handle direct list response
        return data
            .map((json) => CommunityChallengeModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(message: 'Unexpected response format');
      }
    } else {
      throw ServerException(message: 'Failed to load challenges');
    }
  }

  @override
  Future<void> joinChallenge(String challengeId) async {
    final response = await client.post(
      'api/community/challenges/$challengeId/join/',
    );

    if (response.statusCode != 201) {
      throw ServerException(message: 'Failed to join challenge');
    }
  }

  @override
  Future<void> completeChallenge(String challengeId) async {
    final response = await client.post(
      'api/community/challenges/$challengeId/complete/',
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to complete challenge');
    }
  }

  @override
  Future<List<SuccessStoryModel>> getSuccessStories({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) {
      queryParams['category'] = category;
    }
    // Add no_pagination parameter to get all results if possible
    queryParams['no_pagination'] = true;

    final response = await client.get(
      'api/community/success-stories/',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        // Handle paginated response
        return (data['results'] as List)
            .map((json) => SuccessStoryModel.fromJson(json))
            .toList();
      } else if (data is List) {
        // Handle direct list response
        return data.map((json) => SuccessStoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Unexpected response format');
      }
    } else {
      throw ServerException(message: 'Failed to load success stories');
    }
  }

  @override
  Future<SuccessStoryModel> createSuccessStory(
      String title, String content, String category,
      {bool isAnonymous = false}) async {
    final response = await client.post(
      'api/community/success-stories/',
      data: {
        'title': title,
        'content': content,
        'category': category,
        'is_anonymous': isAnonymous,
      },
    );

    if (response.statusCode == 201) {
      return SuccessStoryModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Failed to create success story');
    }
  }

  @override
  Future<void> toggleStoryEncouragement(String storyId) async {
    final response = await client.post(
      'api/community/story-encouragements/toggle/',
      data: {'story': storyId},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(message: 'Failed to toggle story encouragement');
    }
  }
}
