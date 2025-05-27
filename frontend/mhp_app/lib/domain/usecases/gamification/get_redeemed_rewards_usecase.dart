// get_redeemed_rewards_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/reward.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';

class GetRedeemedRewardsUseCase implements UseCase<List<UserReward>, NoParams> {
  final GamificationRepository repository;

  GetRedeemedRewardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserReward>>> call(NoParams params) {
    return repository.getRedeemedRewards();
  }
}
