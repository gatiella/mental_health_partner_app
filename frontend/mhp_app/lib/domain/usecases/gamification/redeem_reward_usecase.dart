// lib/domain/usecases/gamification/redeem_reward_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/reward.dart';

class RedeemRewardUseCase implements UseCase<UserReward, RedeemRewardParams> {
  final GamificationRepository repository;

  RedeemRewardUseCase(this.repository);

  @override
  Future<Either<Failure, UserReward>> call(RedeemRewardParams params) {
    return repository.redeemReward(params.rewardId);
  }
}

class RedeemRewardParams extends Equatable {
  final int rewardId;

  const RedeemRewardParams({required this.rewardId});

  @override
  List<Object> get props => [rewardId];
}
