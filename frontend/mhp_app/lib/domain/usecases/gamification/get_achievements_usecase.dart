// lib/domain/usecases/gamification/get_achievements_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/achievement.dart';

class GetAchievementsUseCase implements UseCase<List<Achievement>, NoParams> {
  final GamificationRepository repository;

  GetAchievementsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Achievement>>> call(NoParams params) {
    return repository.getAchievements();
  }
}
