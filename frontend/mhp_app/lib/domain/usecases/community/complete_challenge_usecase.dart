// lib/domain/usecases/community/complete_challenge_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class CompleteChallengeUseCase {
  final CommunityRepository repository;

  CompleteChallengeUseCase(this.repository);

  Future<Either<Failure, bool>> call(String challengeId) async {
    return await repository.completeChallenge(challengeId);
  }
}
