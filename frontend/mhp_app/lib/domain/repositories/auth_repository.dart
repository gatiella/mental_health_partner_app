// lib/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login(
    String email,
    String password,
  );
  Future<Either<Failure, Map<String, dynamic>>> register(
    Map<String, dynamic> userData,
  );
  Future<Either<Failure, UserModel>> getUserProfile();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, bool>> isAuthenticated();
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure, String>> resetPassword(String token, String password);
}
