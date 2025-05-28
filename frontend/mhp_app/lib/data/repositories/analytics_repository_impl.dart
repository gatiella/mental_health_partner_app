import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/data/datasources/local/analytics_local_data_source.dart';
import 'package:mental_health_partner/data/models/analytics_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/remote/analytics_remote_data_source.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final AnalyticsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AnalyticsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MoodAnalytics>> getMoodAnalytics() async {
    if (await networkInfo.isConnected) {
      try {
        final analyticsJson = await remoteDataSource.getMoodAnalytics();
        final moodAnalytics = MoodAnalytics.fromJson(analyticsJson);
        await localDataSource.cacheMoodAnalytics(moodAnalytics);
        return Right(moodAnalytics);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      final cached = await localDataSource.getCachedMoodAnalytics();
      if (cached != null) return Right(cached);
      return const Left(
          NetworkFailure(message: 'No internet and no cached mood analytics'));
    }
  }

  @override
  Future<Either<Failure, UserActivity>> getUserActivity() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getUserActivity();
        final activity = UserActivity.fromJson(response);
        await localDataSource.cacheUserActivity(activity);
        return Right(activity);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      final cached = await localDataSource.getCachedUserActivity();
      if (cached != null) return Right(cached);
      return const Left(
          NetworkFailure(message: 'No internet and no cached activity data'));
    }
  }
}
