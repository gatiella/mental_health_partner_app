// lib/domain/usecases/auth/get_user_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/user_model.dart';
import '../../repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<Either<Failure, UserModel>> call() {
    return repository.getUserProfile();
  }
}
