// get_rewards_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/reward.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';

class GetRewardsUseCase implements UseCase<List<Reward>, NoParams> {
  final GamificationRepository repository;

  GetRewardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Reward>>> call(NoParams params) {
    return repository.getRewards();
  }
}
