// journal_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/journal.dart';

abstract class JournalRepository {
  Future<Either<Failure, List<Journal>>> getJournalEntries();
  Future<Either<Failure, void>> addJournalEntry(
      String title, String content, String mood);
  Future<Either<Failure, void>> deleteJournalEntry(String entryId);
}
