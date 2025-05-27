// lib/domain/usecases/community/join_challenge_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class JoinChallengeUseCase {
  final CommunityRepository repository;

  JoinChallengeUseCase(this.repository);

  Future<Either<Failure, bool>> call(String challengeId) async {
    return await repository.joinChallenge(challengeId);
  }
}
