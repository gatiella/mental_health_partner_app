import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/quest.dart';
import '../../repositories/gamification_repository.dart';

class GetQuestsUseCase implements UseCase<List<Quest>, NoParams> {
  final GamificationRepository repository;

  GetQuestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Quest>>> call(NoParams params) {
    return repository.getQuests();
  }
}
