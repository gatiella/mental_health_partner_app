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
  final String userId;

  const Journal({
    required this.id,
    required this.title,
    required this.content,
    this.moodScore,
    this.moodNote,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'].toString(),
      title: json['title'],
      content: json['content'],
      moodScore: json['mood_score'],
      moodNote: json['mood_note'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userId: json['user'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood_score': moodScore,
      'mood_note': moodNote,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': userId,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, content, moodScore, moodNote, createdAt, updatedAt, userId];
}
