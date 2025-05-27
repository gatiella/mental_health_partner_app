import 'package:equatable/equatable.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();
}

class LoadJournalEntries extends JournalEvent {
  @override
  List<Object> get props => [];
}

class AddJournalEntry extends JournalEvent {
  final String title;
  final String content;
  final String mood;

  const AddJournalEntry({
    required this.title,
    required this.content,
    required this.mood,
  });

  @override
  List<Object> get props => [title, content, mood];
}

class LoadJournalEntry extends JournalEvent {
  final String entryId;
  const LoadJournalEntry(this.entryId);

  @override
  List<Object> get props => [entryId];
}

class DeleteJournalEntry extends JournalEvent {
  final String entryId;

  const DeleteJournalEntry(this.entryId);

  @override
  List<Object> get props => [entryId];
}
