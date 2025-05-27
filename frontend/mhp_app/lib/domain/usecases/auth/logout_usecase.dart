// lib/domain/usecases/auth/logout_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, bool>> call() {
    return repository.logout();
  }
}
