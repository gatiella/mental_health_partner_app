import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/domain/entities/mood.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/local/mood_local_data_source.dart';
import '../datasources/remote/mood_remote_data_source.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDataSource remoteDataSource;
  final MoodLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MoodRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> recordMood(int rating, String notes) async {
    if (await networkInfo.isConnected) {
      try {
        print('Recording mood with rating: $rating, notes: $notes');
        final mood = await remoteDataSource.recordMood(rating, notes);
        print('Mood recorded successfully, caching locally');
        await localDataSource.cacheMood(mood);
        return const Right(null);
      } on ServerException catch (e) {
        print('Server exception when recording mood: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('Unexpected error when recording mood: $e');
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print('No internet connection when trying to record mood');
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Mood>>> getMoodHistory() async {
    if (await networkInfo.isConnected) {
      try {
        print('Fetching mood history from remote source');
        final remoteHistory = await remoteDataSource.getMoodHistory();
        print(
            'Successfully fetched ${remoteHistory.length} mood entries from remote');

        // Cache the fetched data locally
        await localDataSource.cacheMoodHistory(remoteHistory);

        // Convert MoodModel to Mood entity
        final entities =
            remoteHistory.map((model) => model.toEntity()).toList();
        print('Converted ${entities.length} models to entities');

        return Right(entities);
      } on ServerException catch (e) {
        print('Server exception when fetching mood history: ${e.message}');
        // Try to get cached data if server request fails
        try {
          print('Attempting to get cached mood history');
          final localHistory = await localDataSource.getCachedMoodHistory();
          final entities =
              localHistory.map((model) => model.toEntity()).toList();
          print('Retrieved ${entities.length} mood entries from cache');
          return Right(entities);
        } on CacheException catch (cacheEx) {
          print('Cache exception: ${cacheEx.message}');
          return Left(ServerFailure(message: e.message));
        }
      } catch (e) {
        print('Unexpected error when fetching mood history: $e');
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // No internet, try to get cached data
      try {
        print('No internet, fetching mood history from local cache');
        final localHistory = await localDataSource.getCachedMoodHistory();
        final entities = localHistory.map((model) => model.toEntity()).toList();
        print('Retrieved ${entities.length} mood entries from cache');
        return Right(entities);
      } on CacheException catch (e) {
        print('Cache exception: ${e.message}');
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        print('Unexpected error when fetching cached mood history: $e');
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMoodAnalytics() async {
    if (await networkInfo.isConnected) {
      try {
        print('Fetching mood analytics from remote source');
        final analytics = await remoteDataSource.getMoodAnalytics();
        print('Successfully fetched mood analytics');
        return Right(analytics);
      } on ServerException catch (e) {
        print('Server exception when fetching mood analytics: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('Unexpected error when fetching mood analytics: $e');
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print('No internet connection when trying to fetch mood analytics');
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
