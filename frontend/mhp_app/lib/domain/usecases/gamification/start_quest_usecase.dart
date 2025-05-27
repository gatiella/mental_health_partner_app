// start_quest_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/quest.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';

class StartQuestUseCase implements UseCase<UserQuest, StartQuestParams> {
  final GamificationRepository repository;

  StartQuestUseCase(this.repository);

  @override
  Future<Either<Failure, UserQuest>> call(StartQuestParams params) {
    return repository.startQuest(params.questId, params.moodBefore);
  }
}

class StartQuestParams extends Equatable {
  final int questId;
  final int? moodBefore;

  const StartQuestParams({required this.questId, this.moodBefore});

  @override
  List<Object?> get props => [questId, moodBefore];
}
