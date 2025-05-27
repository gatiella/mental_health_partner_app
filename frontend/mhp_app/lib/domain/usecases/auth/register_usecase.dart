// lib/domain/usecases/auth/register_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
    Map<String, dynamic> userData,
  ) {
    return repository.register(userData);
  }
}
