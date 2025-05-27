import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';
import 'package:mental_health_partner/domain/entities/community_engagement.dart';

class GetCommunityEngagement implements UseCase<CommunityEngagement, NoParams> {
  final CommunityRepository repository;

  GetCommunityEngagement(this.repository);

  @override
  Future<Either<Failure, CommunityEngagement>> call(NoParams params) async {
    return await repository.getCommunityEngagement();
  }
}
