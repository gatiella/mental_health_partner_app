import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/data/models/analytics_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/remote/analytics_remote_data_source.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AnalyticsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MoodAnalytics>> getMoodAnalytics() async {
    if (await networkInfo.isConnected) {
      try {
        final analyticsJson = await remoteDataSource.getMoodAnalytics();
        final analytics = MoodAnalytics.fromJson(analyticsJson);
        return Right(analytics);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserActivity>> getUserActivity() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getUserActivity();
        // Convert to UserActivity model
        final activity = UserActivity.fromJson(response);
        return Right(activity);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(
            message: 'Error parsing activity data: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
