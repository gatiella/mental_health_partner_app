// domain/entities/journal.dart
import 'package:equatable/equatable.dart';

class Journal extends Equatable {
  final String id;
  final String title;
  final String content;
  final int? moodScore;
  final String? moodNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId; // Added to match with JournalModel

  const Journal({
    required this.id,
    required this.title,
    required this.content,
    this.moodScore,
    this.moodNote,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        moodScore,
        moodNote,
        createdAt,
        updatedAt,
        userId,
      ];
}
