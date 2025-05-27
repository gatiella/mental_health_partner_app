import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/data/models/analytics_model.dart';
import '../../core/errors/failure.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, MoodAnalytics>> getMoodAnalytics();
  Future<Either<Failure, UserActivity>> getUserActivity();
}
