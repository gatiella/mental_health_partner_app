import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/exceptions.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/network/network_info.dart';
import 'package:mental_health_partner/domain/entities/journal.dart';
import 'package:mental_health_partner/domain/repositories/journal_repository.dart';
import '../datasources/local/journal_local_data_source.dart';
import '../datasources/remote/journal_remote_data_source.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalRemoteDataSource remoteDataSource;
  final JournalLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  JournalRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Journal>>> getJournalEntries() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEntries = await remoteDataSource.getEntries();
        await localDataSource.cacheJournalEntries(remoteEntries);
        // JournalModel now properly extends Journal, so this is type-safe
        return Right(remoteEntries);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final localEntries = await localDataSource.getCachedJournalEntries();
        return Right(localEntries);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Journal>> addJournalEntry(
      String title, String content, String mood) async {
    if (await networkInfo.isConnected) {
      try {
        final newEntry =
            await remoteDataSource.createEntry(title, content, mood);
        localDataSource.clearCache(); // Clear cache after successful addition
        return Right(newEntry);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJournalEntry(String entryId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteEntry(entryId);
        localDataSource.clearCache(); // Clear cache after deletion
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
