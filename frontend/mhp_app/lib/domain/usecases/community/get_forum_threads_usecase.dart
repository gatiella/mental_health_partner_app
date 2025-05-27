// lib/domain/usecases/community/get_forum_threads_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/forum_thread.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class GetForumThreadsUseCase {
  final CommunityRepository repository;

  GetForumThreadsUseCase(this.repository);

  Future<Either<Failure, List<ForumThread>>> call({String? groupId}) async {
    return await repository.getForumThreads(groupId: groupId);
  }
}
