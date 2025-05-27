import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/domain/entities/journal.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/journal_repository.dart';

class GetJournalEntriesUseCase {
  final JournalRepository repository;

  GetJournalEntriesUseCase(this.repository);

  Future<Either<Failure, List<Journal>>> call() {
    return repository.getJournalEntries();
  }
}
