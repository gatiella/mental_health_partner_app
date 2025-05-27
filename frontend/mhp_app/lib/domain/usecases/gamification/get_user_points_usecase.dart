// get_user_points_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/user_points.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';

class GetUserPointsUseCase implements UseCase<UserPoints, NoParams> {
  final GamificationRepository repository;

  GetUserPointsUseCase(this.repository);

  @override
  Future<Either<Failure, UserPoints>> call(NoParams params) {
    return repository.getUserPoints();
  }
}
