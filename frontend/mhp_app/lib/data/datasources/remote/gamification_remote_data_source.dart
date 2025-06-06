import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mental_health_partner/core/errors/exceptions.dart';
import 'package:mental_health_partner/data/models/%20user_points_model.dart';
import 'package:mental_health_partner/data/models/achievement_model.dart';
import 'package:mental_health_partner/data/models/quest_model.dart';
import 'package:mental_health_partner/data/models/reward_model.dart';
import 'package:mental_health_partner/data/datasources/local/auth_local_data_source.dart';
import 'package:mental_health_partner/data/models/user_quest_model.dart';
import 'package:mental_health_partner/data/models/user_streak_model.dart';

abstract class GamificationRemoteDataSource {
  Future<List<QuestModel>> getQuests();
  Future<List<QuestModel>> getRecommendedQuests();
  Future<UserQuestModel> startQuest(int questId, int? moodBefore);
  Future<Map<String, dynamic>> completeQuest(
      int userQuestId, String? reflection, int? moodAfter);

  Future<List<AchievementModel>> getAchievements();
  Future<List<UserAchievementModel>> getEarnedAchievements();

  Future<List<RewardModel>> getRewards();
  Future<List<UserRewardModel>> getRedeemedRewards();
  Future<UserRewardModel> redeemReward(int rewardId);

  Future<UserPointsModel> getUserPoints();

  Future<UserStreakModel> getUserStreak();
  Future<List<DateTime>> getCompletedQuestDates();
}

class GamificationRemoteDataSourceImpl implements GamificationRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final AuthLocalDataSource authLocalDataSource;

  GamificationRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.authLocalDataSource,
  });

  Uri _buildUrl(String endpoint) {
    final normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final normalizedEndpoint =
        endpoint.startsWith('/') ? endpoint : '/$endpoint';

    return Uri.parse('$normalizedBaseUrl$normalizedEndpoint');
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await authLocalDataSource.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<QuestModel>> getQuests() async {
    final response = await client.get(
      _buildUrl('api/gamification/quests/'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      try {
        final dynamic decodedBody = json.decode(response.body);
        final List<dynamic> rawData = _extractQuestList(decodedBody);

        return rawData
            .map((item) {
              try {
                return QuestModel.fromJson(_sanitizeJson(item));
              } catch (e) {
                print('Error parsing quest item: ${e.toString()}\nItem: $item');
                return null;
              }
            })
            .whereType<QuestModel>()
            .toList();
      } catch (e) {
        throw ServerException(
          message: 'Failed to parse quests: ${e.toString()}',
        );
      }
    }
    return _handleQuestError(response);
  }

  @override
  Future<List<QuestModel>> getRecommendedQuests() async {
    try {
      final response = await client.get(
        _buildUrl('api/gamification/quests/recommended/'),
        headers: await _buildHeaders(),
      );

      if (response.statusCode == 200) {
        try {
          final dynamic decodedBody = json.decode(response.body);
          final List<dynamic> rawData = _extractQuestList(decodedBody);

          print('Recommended quests raw data: $rawData'); // Debug log

          return rawData
              .map((item) {
                try {
                  return QuestModel.fromJson(_sanitizeJson(item));
                } catch (e) {
                  print(
                      'Error parsing recommended quest: ${e.toString()}\nItem: $item');
                  return null;
                }
              })
              .whereType<QuestModel>()
              .toList();
        } catch (e) {
          print('JSON parsing error: ${e.toString()}');
          throw ServerException(
            message: 'Failed to parse recommended quests: ${e.toString()}',
          );
        }
      }
      print(
          'Recommended quests API error status: ${response.statusCode}, body: ${response.body}');
      return _handleQuestError(response);
    } catch (e) {
      print('Unexpected error in getRecommendedQuests: ${e.toString()}');
      throw ServerException(
        message: 'Failed to load recommended quests: ${e.toString()}',
      );
    }
  }

  List<dynamic> _extractQuestList(dynamic decodedBody) {
    if (decodedBody is List) return decodedBody;
    if (decodedBody is Map<String, dynamic>) {
      return decodedBody['results'] ?? decodedBody['data'] ?? [];
    }
    throw const FormatException('Unexpected response format');
  }

  Map<String, dynamic> _sanitizeJson(dynamic jsonItem) {
    try {
      final Map<String, dynamic> cleaned = {};
      final Map<String, dynamic> source =
          jsonItem is Map<String, dynamic> ? jsonItem : {};

      source.forEach((key, value) {
        // Preserve nested structures but clean up nulls
        if (value != null) {
          cleaned[key] =
              value is Map<String, dynamic> ? _sanitizeJson(value) : value;
        }
      });

      return cleaned;
    } catch (e) {
      print('Sanitization error: $e');
      return {};
    }
  }

  Never _handleQuestError(http.Response response) {
    if (response.statusCode == 401) {
      throw const AuthException(
        message: 'Authentication failed. Please log in again.',
      );
    }
    throw ServerException(
      message: 'Failed to load quests: ${response.statusCode}',
    );
  }

  @override
  Future<UserQuestModel> startQuest(int questId, int? moodBefore) async {
    final response = await client.post(
      _buildUrl('api/gamification/user-quests/'),
      headers: await _buildHeaders(),
      body: jsonEncode({
        'quest_id': questId,
        'mood_before': moodBefore,
      }),
    );

    if (response.statusCode == 201) {
      return UserQuestModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to start quest: ${response.statusCode}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> completeQuest(
      int userQuestId, String? reflection, int? moodAfter) async {
    final response = await client.post(
      _buildUrl('api/gamification/user-quests/$userQuestId/complete/'),
      headers: await _buildHeaders(),
      body: jsonEncode({
        'reflection': reflection,
        'mood_after': moodAfter,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to complete quest: ${response.statusCode}',
      );
    }
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    final response = await client.get(
      _buildUrl('api/gamification/achievements/'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);
      List<AchievementModel> results = [];

      if (decodedBody is List) {
        results =
            decodedBody.map((json) => AchievementModel.fromJson(json)).toList();
      } else if (decodedBody is Map<String, dynamic>) {
        final data = decodedBody['results'] ?? decodedBody['data'];
        if (data is List) {
          results =
              data.map((json) => AchievementModel.fromJson(json)).toList();
        }
      }
      return results;
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to load achievements: ${response.statusCode}',
      );
    }
  }

  @override
  Future<List<UserAchievementModel>> getEarnedAchievements() async {
    final response = await client.get(
      _buildUrl('api/gamification/achievements/user_achievements/'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);

      if (decodedBody is List) {
        return decodedBody
            .map((json) => UserAchievementModel.fromJson(json))
            .toList();
      } else if (decodedBody is Map<String, dynamic>) {
        if (decodedBody.containsKey('data') && decodedBody['data'] is List) {
          final List<dynamic> achievementsJson = decodedBody['data'];
          return achievementsJson
              .map((json) => UserAchievementModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to load earned achievements: ${response.statusCode}',
      );
    }
  }

  @override
  Future<List<RewardModel>> getRewards() async {
    final response = await client.get(
      _buildUrl('api/gamification/rewards/'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);
      List<RewardModel> results = [];

      if (decodedBody is List) {
        results =
            decodedBody.map((json) => RewardModel.fromJson(json)).toList();
      } else if (decodedBody is Map<String, dynamic>) {
        final data = decodedBody['results'] ?? decodedBody['data'];
        if (data is List) {
          results = data.map((json) => RewardModel.fromJson(json)).toList();
        }
      }
      return results;
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to load rewards: ${response.statusCode}',
      );
    }
  }

  @override
  Future<List<UserRewardModel>> getRedeemedRewards() async {
    final response = await client.get(
      _buildUrl('api/gamification/rewards/redeemed/'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);

      if (decodedBody is List) {
        return decodedBody
            .map((json) => UserRewardModel.fromJson(json))
            .toList();
      } else if (decodedBody is Map<String, dynamic>) {
        if (decodedBody.containsKey('data') && decodedBody['data'] is List) {
          final List<dynamic> rewardsJson = decodedBody['data'];
          return rewardsJson
              .map((json) => UserRewardModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to load redeemed rewards: ${response.statusCode}',
      );
    }
  }

  @override
  Future<UserRewardModel> redeemReward(int rewardId) async {
    final response = await client.post(
      _buildUrl('api/gamification/rewards/redeem/'),
      headers: await _buildHeaders(),
      body: jsonEncode({'reward_id': rewardId}),
    );

    if (response.statusCode == 200) {
      return UserRewardModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to redeem reward: ${response.statusCode}',
      );
    }
  }

  @override
  Future<UserPointsModel> getUserPoints() async {
    final response = await client.get(
      _buildUrl('api/gamification/points/'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      // ADD THIS DEBUG LINE
      print('Points API Response: ${response.body}');

      try {
        final responseData = json.decode(response.body);
        // ADD THIS DEBUG LINE TOO
        print('Parsed response data: $responseData');

        final pointsData =
            responseData is List ? responseData.first : responseData;
        return UserPointsModel.fromJson(pointsData);
      } catch (e) {
        // ADD THIS DEBUG LINE
        print('Points parsing error: $e');
        return UserPointsModel(
          totalPoints: 0,
          currentPoints: 0,
          lastUpdated: DateTime.now(),
        );
      }
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to load user points: ${response.statusCode}',
      );
    }
  }

  @override
  Future<UserStreakModel> getUserStreak() async {
    final response = await client.get(
      _buildUrl('api/gamification/streak/'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(response.body);
        return UserStreakModel.fromJson(jsonData);
      } catch (e) {
        // If parsing fails, return a default streak
        return const UserStreakModel(
          currentStreak: 0,
          longestStreak: 0,
          lastCompletionDate: null,
          completedToday: false,
          daysUntilNextLevel: 7,
          nextLevelName: "Week Warrior",
        );
      }
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to load user streak: ${response.statusCode}',
      );
    }
  }

  @override
  Future<List<DateTime>> getCompletedQuestDates() async {
    final response = await client.get(
      _buildUrl('api/gamification/completed-dates/'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      try {
        final dynamic decodedBody = json.decode(response.body);
        List<DateTime> dates = [];

        if (decodedBody is List) {
          dates = decodedBody
              .map((dateStr) => DateTime.parse(dateStr.toString()))
              .toList();
        } else if (decodedBody is Map<String, dynamic>) {
          final datesList = decodedBody['dates'] ?? decodedBody['data'] ?? [];
          if (datesList is List) {
            dates = datesList
                .map((dateStr) => DateTime.parse(dateStr.toString()))
                .toList();
          }
        }

        return dates;
      } catch (e) {
        // Return empty list if parsing fails
        return [];
      }
    } else if (response.statusCode == 401) {
      throw const AuthException(
          message: 'Authentication failed. Please log in again.');
    } else {
      throw ServerException(
        message: 'Failed to load completed quest dates: ${response.statusCode}',
      );
    }
  }
}
