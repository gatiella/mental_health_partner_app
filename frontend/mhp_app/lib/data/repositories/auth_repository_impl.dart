import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.login(email, password);

        // Cache tokens
        await localDataSource.cacheTokens(
          response['access'],
          response['refresh'],
        );

        // Get and cache user profile
        final userProfile = await remoteDataSource.getUserProfile();
        await localDataSource.cacheUser(userProfile);

        return Right(response);
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(
    Map<String, dynamic> userData,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.register(userData);

        // Cache tokens if returned directly after registration
        if (response.containsKey('access') && response.containsKey('refresh')) {
          await localDataSource.cacheTokens(
            response['access'],
            response['refresh'],
          );

          // Get and cache user profile
          final userProfile = await remoteDataSource.getUserProfile();
          await localDataSource.cacheUser(userProfile);
        }

        return Right(response);
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserProfile() async {
    try {
      // Try to get from local cache first
      final cachedUser = await localDataSource.getUser();

      if (cachedUser != null) {
        return Right(cachedUser);
      }

      // If not in cache and online, fetch from API
      if (await networkInfo.isConnected) {
        try {
          final userProfile = await remoteDataSource.getUserProfile();
          await localDataSource.cacheUser(userProfile);
          return Right(userProfile);
        } on UnauthorizedException catch (e) {
          return Left(AuthFailure(message: e.message));
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await localDataSource.clearAuth();
      return const Right(true);
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to logout'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return const Left(
        CacheFailure(message: 'Failed to check authentication status'),
      );
    }
  }
}
