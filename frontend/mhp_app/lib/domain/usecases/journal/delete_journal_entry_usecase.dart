import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/journal_repository.dart';

class DeleteJournalEntryUseCase {
  final JournalRepository repository;

  DeleteJournalEntryUseCase(this.repository);

  Future<Either<Failure, void>> call(String entryId) {
    return repository.deleteJournalEntry(entryId);
  }
}
