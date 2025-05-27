// get_earned_achievements_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/achievement.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';

class GetEarnedAchievementsUseCase
    implements UseCase<List<UserAchievement>, NoParams> {
  final GamificationRepository repository;

  GetEarnedAchievementsUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserAchievement>>> call(NoParams params) {
    return repository.getEarnedAchievements();
  }
}
