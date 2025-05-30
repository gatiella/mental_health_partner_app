import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
