// add_journal_entry_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/journal_repository.dart';

class AddJournalEntryUseCase {
  final JournalRepository repository;

  AddJournalEntryUseCase(this.repository);

  Future<Either<Failure, void>> call(
      String title, String content, String mood) {
    return repository.addJournalEntry(title, content, mood);
  }
}
