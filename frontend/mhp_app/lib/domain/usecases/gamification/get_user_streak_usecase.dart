// frontend/lib/domain/usecases/gamification/get_user_streak_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/user_streak.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';

class GetUserStreakUseCase implements UseCase<UserStreak, NoParams> {
  final GamificationRepository repository;

  GetUserStreakUseCase(this.repository);

  @override
  Future<Either<Failure, UserStreak>> call(NoParams params) async {
    return await repository.getUserStreak();
  }
}
