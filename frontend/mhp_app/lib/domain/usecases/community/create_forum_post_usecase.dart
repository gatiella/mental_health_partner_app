// lib/domain/usecases/community/create_forum_post_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/forum_post.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class CreateForumPostUseCase {
  final CommunityRepository repository;

  CreateForumPostUseCase(this.repository);

  Future<Either<Failure, ForumPost>> call({
    required String threadId,
    required String content,
    bool isAnonymous = false,
  }) async {
    return await repository.createForumPost(
      threadId,
      content,
      isAnonymous: isAnonymous,
    );
  }
}
