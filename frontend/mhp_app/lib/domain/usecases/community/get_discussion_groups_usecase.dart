// lib/domain/usecases/community/get_discussion_groups_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/discussion_group.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class GetDiscussionGroupsUseCase {
  final CommunityRepository repository;

  GetDiscussionGroupsUseCase(this.repository);

  Future<Either<Failure, List<DiscussionGroup>>> call({String? topic}) async {
    return await repository.getDiscussionGroups(topic: topic);
  }
}
