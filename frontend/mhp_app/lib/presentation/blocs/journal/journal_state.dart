import 'package:equatable/equatable.dart';
import '../../../../domain/entities/journal.dart';

abstract class JournalState extends Equatable {
  const JournalState();
}

class JournalInitial extends JournalState {
  @override
  List<Object> get props => [];
}

class JournalLoading extends JournalState {
  @override
  List<Object> get props => [];
}

class JournalEntriesLoaded extends JournalState {
  final List<Journal> entries;

  const JournalEntriesLoaded(this.entries);

  @override
  List<Object> get props => [entries];
}

class JournalEntryAdded extends JournalState {
  @override
  List<Object> get props => [];
}

class JournalEntryLoaded extends JournalState {
  final Journal entry;
  const JournalEntryLoaded(this.entry);

  @override
  List<Object> get props => [entry];
}

class JournalError extends JournalState {
  final String message;

  const JournalError(this.message);

  @override
  List<Object> get props => [message];
}
