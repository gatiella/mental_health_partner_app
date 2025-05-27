import 'package:equatable/equatable.dart';
import '../../domain/entities/mood.dart';

class MoodModel extends Equatable {
  final String id;
  final int score; // Changed from rating to score to match backend
  final String? note; // Changed from notes to note to match backend
  final DateTime createdAt;

  const MoodModel({
    required this.id,
    required this.score, // Changed from rating to score
    this.note, // Changed from notes to note
    required this.createdAt,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    // More robust parsing with field names matching the backend
    return MoodModel(
      id: json['id']?.toString() ?? '',
      score: json['score'] is int
          ? json['score']
          : int.tryParse(json['score']?.toString() ?? '0') ?? 0,
      note: json['note'],
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  // Helper method to handle date parsing safely
  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();

    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      } else if (dateValue is int) {
        // Handle timestamp in milliseconds
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score, // Changed from rating to score
      'note': note, // Changed from notes to note
      'created_at': createdAt.toIso8601String(),
    };
  }

  Mood toEntity() => Mood(
        id: id,
        rating: score, // Map score to rating in the entity
        notes: note, // Map note to notes in the entity
        createdAt: createdAt,
        timestamp: createdAt,
      );

  @override
  List<Object> get props => [id, score, createdAt]; // Changed rating to score
}
