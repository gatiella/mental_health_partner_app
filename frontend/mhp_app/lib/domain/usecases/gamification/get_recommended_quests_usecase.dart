// get_recommended_quests_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/quest.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetRecommendedQuestsUseCase implements UseCase<List<Quest>, NoParams> {
  final GamificationRepository repository;

  GetRecommendedQuestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Quest>>> call(NoParams params) {
    return repository.getRecommendedQuests();
  }
}
