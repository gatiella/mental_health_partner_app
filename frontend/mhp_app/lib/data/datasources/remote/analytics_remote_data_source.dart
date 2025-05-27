import 'package:dio/dio.dart';
import '../../../../config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';

abstract class AnalyticsRemoteDataSource {
  Future<Map<String, dynamic>> getMoodAnalytics();
  Future<Map<String, dynamic>> getUserActivity();

  // Community analytics
  Future<Map<String, dynamic>> getCommunityEngagement();
  Future<Map<String, dynamic>> getDiscussionGroupMetrics();
  Future<Map<String, dynamic>> getChallengeCompletionRates();
  Future<Map<String, dynamic>> getForumActivity();
  Future<Map<String, dynamic>> getSuccessStoryImpact();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiClient client;

  AnalyticsRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> getMoodAnalytics() async {
    try {
      final response = await client.get(ApiConfig.moodAnalytics);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to load analytics');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserActivity() async {
    try {
      final response = await client.get(ApiConfig.userActivity);
      // Debug the response
      print('User Activity Response: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to load activity');
    }
  }

  @override
  Future<Map<String, dynamic>> getCommunityEngagement() async {
    try {
      final response = await client.get(ApiConfig.communityEngagement);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to load community engagement');
    }
  }

  @override
  Future<Map<String, dynamic>> getDiscussionGroupMetrics() async {
    try {
      final response = await client.get(ApiConfig.discussionGroupMetrics);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to load discussion group metrics');
    }
  }

  @override
  Future<Map<String, dynamic>> getChallengeCompletionRates() async {
    try {
      final response = await client.get(ApiConfig.challengeCompletionRates);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to load challenge completion rates');
    }
  }

  @override
  Future<Map<String, dynamic>> getForumActivity() async {
    try {
      final response = await client.get(ApiConfig.forumActivity);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to load forum activity');
    }
  }

  @override
  Future<Map<String, dynamic>> getSuccessStoryImpact() async {
    try {
      final response = await client.get(ApiConfig.successStoryImpact);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to load success story impact');
    }
  }
}
