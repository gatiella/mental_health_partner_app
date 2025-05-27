import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/gamification_repository.dart';

class CompleteQuestUseCase
    implements UseCase<Map<String, dynamic>, CompleteQuestParams> {
  final GamificationRepository repository;

  CompleteQuestUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      CompleteQuestParams params) {
    return repository.completeQuest(
        params.userQuestId, params.reflection, params.moodAfter);
  }
}

class CompleteQuestParams extends Equatable {
  final int userQuestId;
  final String? reflection;
  final int? moodAfter;

  const CompleteQuestParams({
    required this.userQuestId,
    this.reflection,
    this.moodAfter,
  });

  @override
  List<Object?> get props => [userQuestId, reflection, moodAfter];
}
