import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/mood_repository.dart';

class GetMoodAnalyticsUseCase {
  final MoodRepository repository;

  GetMoodAnalyticsUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    return await repository.getMoodAnalytics();
  }
}
