import 'package:dio/dio.dart';
import '../../../../config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/mood_model.dart';

abstract class MoodRemoteDataSource {
  Future<MoodModel> recordMood(int rating, String notes);
  Future<List<MoodModel>> getMoodHistory();
  Future<Map<String, dynamic>> getMoodAnalytics();
}

class MoodRemoteDataSourceImpl implements MoodRemoteDataSource {
  final ApiClient client;
  MoodRemoteDataSourceImpl({required this.client});

  @override
  Future<MoodModel> recordMood(int rating, String notes) async {
    try {
      // Match Django backend field names (score and note instead of rating and notes)
      final response = await client.post(
        ApiConfig.moods,
        data: {'score': rating, 'note': notes},
      );

      print('Record mood response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MoodModel.fromJson(response.data);
      } else {
        throw ServerException(
            message: 'Failed to record mood. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException in recordMood: ${e.message}, ${e.response?.data}');
      throw ServerException(message: e.message ?? 'Failed to record mood');
    } catch (e) {
      print('Unexpected error in recordMood: $e');
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<MoodModel>> getMoodHistory() async {
    try {
      final response = await client.get(ApiConfig.moods);

      print('Mood history response status: ${response.statusCode}');
      print('Mood history response type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        // Add more detailed debug logging
        if (response.data is List) {
          print('Response is a List with ${response.data.length} items');
          final results = (response.data as List)
              .map((json) => MoodModel.fromJson(json))
              .toList();
          print('Parsed ${results.length} mood models');
          return results;
        } else if (response.data is Map) {
          print(
              'Response is a Map with keys: ${(response.data as Map).keys.toList()}');

          // Handle DRF paginated response if present
          if (response.data['results'] is List) {
            final results = (response.data['results'] as List)
                .map((json) => MoodModel.fromJson(json))
                .toList();
            print(
                'Parsed ${results.length} mood models from paginated results');
            return results;
          } else {
            // Single item response
            print('Treating response as a single mood item');
            return [MoodModel.fromJson(response.data)];
          }
        } else {
          print('Unexpected response format: ${response.data}');
          return [];
        }
      } else {
        throw ServerException(
            message:
                'Failed to fetch mood history. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException in getMoodHistory: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response headers: ${e.response?.headers}');
      }
      throw ServerException(
          message: e.message ?? 'Failed to fetch mood history');
    } catch (e) {
      print('Unexpected error in getMoodHistory: $e');
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMoodAnalytics() async {
    try {
      // If your Django backend doesn't have a specific analytics endpoint,
      // we'll fetch the mood history and generate analytics client-side
      final moodHistory = await getMoodHistory();

      // Simple analytics calculation
      final analytics = _generateAnalyticsFromHistory(moodHistory);
      return analytics;
    } on DioException catch (e) {
      print(
          'DioException in getMoodAnalytics: ${e.message}, ${e.response?.data}');
      throw ServerException(message: e.message ?? 'Failed to fetch analytics');
    } catch (e) {
      print('Unexpected error in getMoodAnalytics: $e');
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  // Helper method to generate analytics from mood history
  Map<String, dynamic> _generateAnalyticsFromHistory(List<MoodModel> history) {
    // Skip if no history
    if (history.isEmpty) {
      return {'weekly_ratings': []};
    }

    // Calculate average mood score by day of week
    final weeklyRatings = List.generate(7, (index) {
      final dayMoods =
          history.where((mood) => mood.createdAt.weekday == index + 1).toList();

      final average = dayMoods.isEmpty
          ? 0.0
          : dayMoods.map((m) => m.score).reduce((a, b) => a + b) /
              dayMoods.length;

      return {
        'day': index,
        'average': average,
      };
    });

    // Calculate overall average
    final overallAverage = history.isEmpty
        ? 0.0
        : history.map((m) => m.score).reduce((a, b) => a + b) / history.length;

    return {
      'weekly_ratings': weeklyRatings,
      'overall_average': overallAverage,
      'total_entries': history.length,
    };
  }
}
