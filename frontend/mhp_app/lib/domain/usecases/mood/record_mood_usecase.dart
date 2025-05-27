import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/repositories/mood_repository.dart';

class RecordMoodUseCase {
  final MoodRepository repository;

  RecordMoodUseCase(this.repository);

  // We keep the method signature the same to maintain compatibility with existing UI code
  Future<Either<Failure, void>> call(int rating, String notes) async {
    // Validate rating according to backend requirements (1–10)
    if (rating < 1 || rating > 10) {
      return const Left(
        ValidationFailure(message: 'Mood rating must be between 1 and 10'),
      );
    }

    // Validate notes (optional but with length limit in backend)
    if (notes.length > 255) {
      return const Left(
        ValidationFailure(message: 'Notes must be 255 characters or less'),
      );
    }

    // Call repository with validated data
    return await repository.recordMood(rating, notes);
  }
}

// ValidationFailure class if not already defined
class ValidationFailure extends Failure {
  @override
  final String message;

  const ValidationFailure({required this.message}) : super(message: '');

  @override
  List<Object> get props => [message];
}
