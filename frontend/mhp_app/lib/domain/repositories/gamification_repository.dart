// gamification_repository.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/user_points.dart';
import 'package:mental_health_partner/domain/entities/user_streak.dart';
import '../entities/quest.dart';
import '../entities/achievement.dart';
import '../entities/reward.dart';

abstract class GamificationRepository {
  Future<Either<Failure, List<Quest>>> getQuests();
  Future<Either<Failure, List<Quest>>> getRecommendedQuests();
  Future<Either<Failure, UserQuest>> startQuest(int questId, int? moodBefore);
  Future<Either<Failure, Map<String, dynamic>>> completeQuest(
      int userQuestId, String? reflection, int? moodAfter);
  Future<Either<Failure, List<Achievement>>> getAchievements();
  Future<Either<Failure, List<UserAchievement>>> getEarnedAchievements();
  Future<Either<Failure, List<Reward>>> getRewards();
  Future<Either<Failure, List<UserReward>>> getRedeemedRewards();
  Future<Either<Failure, UserReward>> redeemReward(int rewardId);
  Future<Either<Failure, UserPoints>> getUserPoints();
  Future<Either<Failure, List<DateTime>>> getCompletedQuestDates();
  Future<Either<Failure, UserStreak>> getUserStreak();
}
