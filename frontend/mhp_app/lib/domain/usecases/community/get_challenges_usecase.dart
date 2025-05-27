// lib/domain/usecases/community/get_challenges_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/community_challenge.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class GetChallengesUseCase {
  final CommunityRepository repository;

  GetChallengesUseCase(this.repository);

  Future<Either<Failure, List<CommunityChallenge>>> call({String? type}) async {
    return await repository.getChallenges(type: type);
  }
}
