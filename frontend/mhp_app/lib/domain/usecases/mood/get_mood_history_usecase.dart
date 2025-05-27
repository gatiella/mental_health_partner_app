import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/domain/entities/mood.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/mood_repository.dart';

class GetMoodHistoryUseCase {
  final MoodRepository repository;

  GetMoodHistoryUseCase(this.repository);

  Future<Either<Failure, List<Mood>>> call() {
    return repository.getMoodHistory();
  }
}
