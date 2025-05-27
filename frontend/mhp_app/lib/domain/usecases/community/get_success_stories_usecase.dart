// lib/domain/usecases/community/get_success_stories_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/success_story.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class GetSuccessStoriesUseCase {
  final CommunityRepository repository;

  GetSuccessStoriesUseCase(this.repository);

  Future<Either<Failure, List<SuccessStory>>> call({String? category}) async {
    return await repository.getSuccessStories(category: category);
  }
}
