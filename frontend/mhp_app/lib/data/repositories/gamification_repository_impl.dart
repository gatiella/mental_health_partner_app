import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/exceptions.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/user_points.dart';
import 'package:mental_health_partner/domain/entities/user_streak.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/quest.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/reward.dart';
import '../../domain/repositories/gamification_repository.dart';
import '../datasources/remote/gamification_remote_data_source.dart';
import '../datasources/local/gamification_local_data_source.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationRemoteDataSource remoteDataSource;
  final GamificationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GamificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Quest>>> getQuests() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getQuests();
        await localDataSource.cacheQuests(remoteQuests);
        return Right(remoteQuests.map((model) => model.toEntity()).toList());
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      try {
        final localQuests = await localDataSource.getLastQuests();
        return Right(localQuests.cast<Quest>());
      } on CacheException {
        return const Left(CacheFailure(message: "No cached data available"));
      }
    }
  }

  @override
  Future<Either<Failure, List<Quest>>> getRecommendedQuests() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getRecommendedQuests();
        return Right(remoteQuests.map((model) => model.toEntity()).toList());
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      return const Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, UserQuest>> startQuest(
      int questId, int? moodBefore) async {
    if (await networkInfo.isConnected) {
      try {
        final userQuestModel =
            await remoteDataSource.startQuest(questId, moodBefore);
        return Right(userQuestModel.toEntity());
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      return const Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> completeQuest(
      int userQuestId, String? reflection, int? moodAfter) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.completeQuest(
            userQuestId, reflection, moodAfter);
        return Right(result);
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      return const Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAchievements() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAchievements = await remoteDataSource.getAchievements();
        await localDataSource.cacheAchievements(remoteAchievements);
        return Right(remoteAchievements.cast<Achievement>());
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      try {
        final localAchievements = await localDataSource.getLastAchievements();
        return Right(localAchievements.cast<Achievement>());
      } on CacheException {
        return const Left(CacheFailure(message: "No cached data available"));
      }
    }
  }

  @override
  Future<Either<Failure, List<UserAchievement>>> getEarnedAchievements() async {
    if (await networkInfo.isConnected) {
      try {
        final earnedAchievements =
            await remoteDataSource.getEarnedAchievements();
        await localDataSource.cacheEarnedAchievements(earnedAchievements);
        return Right(earnedAchievements.cast<UserAchievement>());
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      try {
        final localEarned = await localDataSource.getLastEarnedAchievements();
        return Right(localEarned.cast<UserAchievement>());
      } on CacheException {
        return const Left(CacheFailure(message: "No cached data available"));
      }
    }
  }

  @override
  Future<Either<Failure, UserPoints>> getUserPoints() async {
    if (await networkInfo.isConnected) {
      try {
        final points = await remoteDataSource.getUserPoints();
        await localDataSource.cacheUserPoints(points);
        // Convert the model to entity directly
        return Right(UserPoints(
          totalPoints: points.totalPoints,
          currentPoints: points.currentPoints,
          lastUpdated: points.lastUpdated,
        ));
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      try {
        final localPoints = await localDataSource.getLastUserPoints();
        // Convert the model to entity directly
        return Right(UserPoints(
          totalPoints: localPoints.totalPoints,
          currentPoints: localPoints.currentPoints,
          lastUpdated: localPoints.lastUpdated,
        ));
      } on CacheException {
        return const Left(CacheFailure(message: "No cached data available"));
      }
    }
  }

  @override
  Future<Either<Failure, List<UserReward>>> getRedeemedRewards() async {
    if (await networkInfo.isConnected) {
      try {
        final rewards = await remoteDataSource.getRedeemedRewards();
        await localDataSource.cacheRedeemedRewards(rewards);
        return Right(rewards.cast<UserReward>());
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      try {
        final local = await localDataSource.getLastRedeemedRewards();
        return Right(local.cast<UserReward>());
      } on CacheException {
        return const Left(CacheFailure(message: "No cached data available"));
      }
    }
  }

  @override
  Future<Either<Failure, List<Reward>>> getRewards() async {
    if (await networkInfo.isConnected) {
      try {
        final rewards = await remoteDataSource.getRewards();
        await localDataSource.cacheRewards(rewards);
        return Right(rewards.cast<Reward>());
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      try {
        final local = await localDataSource.getLastRewards();
        return Right(local.cast<Reward>());
      } on CacheException {
        return const Left(CacheFailure(message: "No cached data available"));
      }
    }
  }

  @override
  Future<Either<Failure, UserReward>> redeemReward(int rewardId) async {
    if (await networkInfo.isConnected) {
      try {
        final reward = await remoteDataSource.redeemReward(rewardId);
        return Right(reward as UserReward);
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      return const Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, UserStreak>> getUserStreak() async {
    if (await networkInfo.isConnected) {
      try {
        final streak = await remoteDataSource.getUserStreak();
        await localDataSource.cacheUserStreak(streak);
        return Right(streak.toEntity());
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      try {
        final localStreak = await localDataSource.getLastUserStreak();
        return Right(localStreak.toEntity());
      } on CacheException {
        // Return a default streak if no cached data
        return const Right(UserStreak(
          currentStreak: 0,
          longestStreak: 0,
          lastCompletionDate: null,
          completedToday: false,
          daysUntilNextLevel: 7,
          nextLevelName: "Week Warrior",
        ));
      }
    }
  }

  @override
  Future<Either<Failure, List<DateTime>>> getCompletedQuestDates() async {
    if (await networkInfo.isConnected) {
      try {
        final dates = await remoteDataSource.getCompletedQuestDates();
        await localDataSource.cacheCompletedQuestDates(dates);
        return Right(dates);
      } on AuthException {
        return const Left(AuthFailure(
            message: "Authentication failed. Please log in again."));
      } on ServerException {
        return const Left(ServerFailure(message: "Server Error Occurred"));
      }
    } else {
      try {
        final localDates = await localDataSource.getLastCompletedQuestDates();
        return Right(localDates);
      } on CacheException {
        return const Right([]);
      }
    }
  }
}
