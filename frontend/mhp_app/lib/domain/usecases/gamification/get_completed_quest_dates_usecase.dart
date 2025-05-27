// Create: frontend/lib/domain/usecases/gamification/get_completed_quest_dates_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';

class GetCompletedQuestDatesUseCase
    implements UseCase<List<DateTime>, NoParams> {
  final GamificationRepository repository;

  GetCompletedQuestDatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<DateTime>>> call(NoParams params) async {
    return await repository.getCompletedQuestDates();
  }
}
