import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call(String token, String password) async {
    return await repository.resetPassword(token, password);
  }
}
