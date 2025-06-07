import 'dart:convert';
import 'dart:ui';

import 'package:mental_health_partner/core/errors/exceptions.dart';
import 'package:mental_health_partner/core/storage/local_storage.dart';
import 'package:mental_health_partner/data/models/%20user_points_model.dart';
import 'package:mental_health_partner/data/models/achievement_model.dart';
import 'package:mental_health_partner/data/models/quest_model.dart';
import 'package:mental_health_partner/data/models/reward_model.dart';
import 'package:mental_health_partner/data/models/user_level_model.dart';
import 'package:mental_health_partner/data/models/user_progress_model.dart';
import 'package:mental_health_partner/data/models/user_streak_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GamificationLocalDataSource {
  Future<List<QuestModel>> getLastQuests();
  Future<void> cacheQuests(List<QuestModel> quests);

  Future<List<AchievementModel>> getLastAchievements();
  Future<void> cacheAchievements(List<AchievementModel> achievements);

  Future<List<UserAchievementModel>> getLastEarnedAchievements();
  Future<void> cacheEarnedAchievements(List<UserAchievementModel> achievements);

  Future<UserPointsModel> getLastUserPoints();
  Future<void> cacheUserPoints(UserPointsModel points);

  Future<List<RewardModel>> getLastRewards();
  Future<void> cacheRewards(List<RewardModel> rewards);

  Future<List<UserRewardModel>> getLastRedeemedRewards();
  Future<void> cacheRedeemedRewards(List<UserRewardModel> rewards);
  Future<UserStreakModel> getLastUserStreak();
  Future<void> cacheUserStreak(UserStreakModel streak);
  Future<List<DateTime>> getLastCompletedQuestDates();
  Future<void> cacheCompletedQuestDates(List<DateTime> dates);

  Future<List<UserLevelModel>> getLastUserLevels();
  Future<void> cacheUserLevels(List<UserLevelModel> levels);

  Future<UserProgressModel> getLastUserProgress();
  Future<void> cacheUserProgress(UserProgressModel progress);
}

class GamificationLocalDataSourceImpl implements GamificationLocalDataSource {
  final LocalStorage storage;
  final SharedPreferences sharedPreferences;

  static const String questsKey = 'cached_quests';
  static const String achievementsKey = 'cached_achievements';
  static const String earnedAchievementsKey = 'earned_achievements';
  static const String userPointsKey = 'user_points';
  static const String rewardsKey = 'cached_rewards';
  static const String redeemedRewardsKey = 'redeemed_rewards';

  static const String userLevelsKey = 'cached_user_levels';
  static const String userProgressKey = 'cached_user_progress';

  GamificationLocalDataSourceImpl(this.sharedPreferences,
      {required this.storage});

  @override
  Future<void> cacheQuests(List<QuestModel> quests) async {
    await storage.write(
      questsKey,
      quests.map((quest) => quest.toJson()).toList(),
    );
  }

  @override
  Future<List<QuestModel>> getLastQuests() async {
    final data = await storage.read<List>(questsKey);
    return data?.map((json) => QuestModel.fromJson(json)).toList() ?? [];
  }

  @override
  Future<void> cacheAchievements(List<AchievementModel> achievements) async {
    await storage.write(
      achievementsKey,
      achievements.map((a) => a.toJson()).toList(),
    );
  }

  @override
  Future<List<AchievementModel>> getLastAchievements() async {
    final data = await storage.read<List>(achievementsKey);
    return data?.map((json) => AchievementModel.fromJson(json)).toList() ?? [];
  }

  @override
  Future<void> cacheEarnedAchievements(
      List<UserAchievementModel> achievements) async {
    await storage.write(
      earnedAchievementsKey,
      achievements.map((a) => a.toJson()).toList(),
    );
  }

  @override
  Future<List<UserAchievementModel>> getLastEarnedAchievements() async {
    final data = await storage.read<List>(earnedAchievementsKey);
    return data?.map((json) => UserAchievementModel.fromJson(json)).toList() ??
        [];
  }

  @override
  Future<void> cacheUserPoints(UserPointsModel points) async {
    await storage.write(userPointsKey, points.toJson());
  }

  @override
  Future<UserPointsModel> getLastUserPoints() async {
    final data = await storage.read<Map<String, dynamic>>(userPointsKey);
    return data != null
        ? UserPointsModel.fromJson(data)
        : UserPointsModel(
            totalPoints: 0,
            currentPoints: 0,
            lastUpdated: DateTime.now(),
          );
  }

  @override
  Future<void> cacheRewards(List<RewardModel> rewards) async {
    await storage.write(
      rewardsKey,
      rewards.map((r) => r.toJson()).toList(),
    );
  }

  @override
  Future<List<RewardModel>> getLastRewards() async {
    final data = await storage.read<List>(rewardsKey);
    return data?.map((json) => RewardModel.fromJson(json)).toList() ?? [];
  }

  @override
  Future<void> cacheRedeemedRewards(List<UserRewardModel> rewards) async {
    await storage.write(
      redeemedRewardsKey,
      rewards.map((r) => r.toJson()).toList(),
    );
  }

  @override
  Future<List<UserRewardModel>> getLastRedeemedRewards() async {
    final data = await storage.read<List>(redeemedRewardsKey);
    return data?.map((json) => UserRewardModel.fromJson(json)).toList() ?? [];
  }

  @override
  Future<UserStreakModel> getLastUserStreak() async {
    final jsonString = sharedPreferences.getString('CACHED_USER_STREAK');
    if (jsonString != null) {
      return UserStreakModel.fromJson(json.decode(jsonString));
    } else {
      throw CacheException(message: 'No cached user streak found');
    }
  }

  @override
  Future<void> cacheUserStreak(UserStreakModel streak) async {
    await sharedPreferences.setString(
      'CACHED_USER_STREAK',
      json.encode(streak.toJson()),
    );
  }

  @override
  Future<List<DateTime>> getLastCompletedQuestDates() async {
    final jsonString = sharedPreferences.getString('CACHED_COMPLETED_DATES');
    if (jsonString != null) {
      final List<dynamic> datesList = json.decode(jsonString);
      return datesList.map((dateStr) => DateTime.parse(dateStr)).toList();
    } else {
      throw CacheException(message: 'No cached completed quest dates found');
    }
  }

  @override
  Future<void> cacheCompletedQuestDates(List<DateTime> dates) async {
    final dateStrings = dates.map((date) => date.toIso8601String()).toList();
    await sharedPreferences.setString(
      'CACHED_COMPLETED_DATES',
      json.encode(dateStrings),
    );
  }

  @override
  Future<void> cacheUserLevels(List<UserLevelModel> levels) async {
    await storage.write(
      userLevelsKey,
      levels.map((level) => level.toJson()).toList(),
    );
  }

  @override
  Future<List<UserLevelModel>> getLastUserLevels() async {
    final data = await storage.read<List>(userLevelsKey);
    return data?.map((json) => UserLevelModel.fromJson(json)).toList() ?? [];
  }

  @override
  Future<void> cacheUserProgress(UserProgressModel progress) async {
    await storage.write(userProgressKey, progress.toJson());
  }

  @override
  Future<UserProgressModel> getLastUserProgress() async {
    final data = await storage.read<Map<String, dynamic>>(userProgressKey);
    if (data != null) {
      return UserProgressModel.fromJson(data);
    } else {
      // Return default progress if no cached data
      return const UserProgressModel(
        currentLevel: 1,
        currentPoints: 0,
        pointsToNextLevel: 100,
        currentLevelData: UserLevelModel(
          level: 1,
          title: 'Beginner',
          description: 'Just starting your journey',
          pointsRequired: 0,
          badgeImage: '',
          perks: ['Basic features'],
          color: Color(0xFF6366F1),
        ),
        nextLevelData: UserLevelModel(
          level: 2,
          title: 'Explorer',
          description: 'Exploring new horizons',
          pointsRequired: 100,
          badgeImage: '',
          perks: ['Advanced features'],
          color: const Color(0xFF8B5CF6),
        ),
        progressPercentage: 0.0,
      );
    }
  }
}
