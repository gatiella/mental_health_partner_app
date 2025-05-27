import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/mood.dart';

abstract class MoodRepository {
  Future<Either<Failure, void>> recordMood(int rating, String notes);
  Future<Either<Failure, List<Mood>>> getMoodHistory(); // Changed to List<Mood>
  Future<Either<Failure, Map<String, dynamic>>> getMoodAnalytics();
}
