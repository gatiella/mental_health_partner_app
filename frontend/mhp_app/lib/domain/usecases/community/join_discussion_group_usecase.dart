import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class JoinDiscussionGroupUseCase {
  final CommunityRepository repository;

  JoinDiscussionGroupUseCase(this.repository);

  Future<Either<Failure, bool>> call(
    String groupSlug, {
    bool isAnonymous = false,
  }) async {
    return await repository.joinDiscussionGroup(
      groupSlug,
      isAnonymous: isAnonymous,
    );
  }
}
