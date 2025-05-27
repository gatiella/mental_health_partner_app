import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/forum_thread.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class GetThreadDetailsUseCase {
  final CommunityRepository repository;

  GetThreadDetailsUseCase(this.repository);

  Future<Either<Failure, ForumThread>> call({required String threadId}) async {
    return await repository.getThreadDetails(threadId);
  }
}
