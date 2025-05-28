import 'package:equatable/equatable.dart';
import '../../domain/entities/mood.dart';

class MoodModel extends Equatable {
  final String id;
  final int score;
  final String? note;
  final DateTime createdAt;

  const MoodModel({
    required this.id,
    required this.score,
    this.note,
    required this.createdAt,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id']?.toString() ?? '',
      score: json['score'] is int
          ? json['score']
          : int.tryParse(json['score']?.toString() ?? '0') ?? 0,
      note: json['note'],
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      } else if (dateValue is int) {
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
      'score': score,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Mood toEntity() => Mood(
        id: id,
        rating: score,
        notes: note,
        createdAt: createdAt,
        timestamp: createdAt,
      );

  @override
  List<Object> get props => [id, score, createdAt];
}
