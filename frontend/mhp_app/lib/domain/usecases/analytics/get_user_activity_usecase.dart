import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/data/models/analytics_model.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/analytics_repository.dart';

class GetUserActivityUseCase {
  final AnalyticsRepository repository;

  GetUserActivityUseCase(this.repository);

  Future<Either<Failure, UserActivity>> call() {
    // Updated return type
    return repository.getUserActivity();
  }
}
