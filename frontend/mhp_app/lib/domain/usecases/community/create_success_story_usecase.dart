import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/success_story.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class CreateSuccessStoryUseCase {
  final CommunityRepository repository;

  CreateSuccessStoryUseCase(this.repository);

  Future<Either<Failure, SuccessStory>> call(
    String title,
    String content,
    String category, {
    bool isAnonymous = false,
  }) async {
    return await repository.createSuccessStory(
      title,
      content,
      category,
      isAnonymous: isAnonymous,
    );
  }
}
