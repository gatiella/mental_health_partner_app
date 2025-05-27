// lib/domain/usecases/community/send_encouragement_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/community_repository.dart';

class SendEncouragementUseCase {
  final CommunityRepository repository;

  SendEncouragementUseCase(this.repository);

  Future<Either<Failure, bool>> call(
    String postId, {
    String type = 'support',
  }) async {
    return await repository.toggleEncouragement(
      postId,
      type: type,
    );
  }
}
