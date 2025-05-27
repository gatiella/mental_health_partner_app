import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/journal/add_journal_entry_usecase.dart';
import '../../../../domain/usecases/journal/delete_journal_entry_usecase.dart';
import '../../../../domain/usecases/journal/get_journal_entries_usecase.dart';
import 'journal_event.dart';
import 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final GetJournalEntriesUseCase getEntries;
  final AddJournalEntryUseCase addEntry;
  final DeleteJournalEntryUseCase deleteEntry;

  JournalBloc({
    required this.getEntries,
    required this.addEntry,
    required this.deleteEntry,
  }) : super(JournalInitial()) {
    on<LoadJournalEntries>(_onLoadEntries);
    on<AddJournalEntry>(_onAddEntry);
    on<DeleteJournalEntry>(_onDeleteEntry);
    on<LoadJournalEntry>(_onLoadEntry);
  }

  Future<void> _onLoadEntries(
    LoadJournalEntries event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    final result = await getEntries();
    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (entries) => emit(JournalEntriesLoaded(entries)),
    );
  }

  Future<void> _onAddEntry(
    AddJournalEntry event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    final result = await addEntry(
      event.title,
      event.content,
      event.mood,
    );
    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (_) {
        add(LoadJournalEntries());
        emit(JournalEntryAdded());
      },
    );
  }

  Future<void> _onLoadEntry(
    LoadJournalEntry event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    // You'll need to create a use case for getting a single entry
    // For now assuming you can filter from the existing entries:
    final result = await getEntries();
    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (entries) {
        final entry = entries.firstWhere(
          (e) => e.id == event.entryId,
          orElse: () => throw Exception('Entry not found'),
        );
        emit(JournalEntryLoaded(entry));
      },
    );
  }

  Future<void> _onDeleteEntry(
    DeleteJournalEntry event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    final result = await deleteEntry(event.entryId);
    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (_) => add(LoadJournalEntries()),
    );
  }
}
