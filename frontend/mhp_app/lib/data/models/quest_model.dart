import 'package:json_annotation/json_annotation.dart';
import 'package:mental_health_partner/domain/entities/quest.dart';

part 'quest_model.g.dart';

@JsonSerializable()
class QuestModel {
  final int id;
  final String title;
  final String description;
  final String category;

  @JsonKey(fromJson: _parseInt)
  final int points;

  @JsonKey(name: 'duration_minutes', fromJson: _parseInt)
  final int durationMinutes;

  final String instructions;

  @JsonKey(fromJson: _parseInt)
  final int difficulty;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'is_completed', fromJson: _parseBool)
  final bool isCompleted;

  @JsonKey(name: 'progress', fromJson: _parseDouble)
  final double progress;

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.points,
    required this.durationMinutes,
    required this.instructions,
    required this.difficulty,
    required this.isCompleted,
    required this.progress,
    this.imageUrl,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) =>
      _$QuestModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestModelToJson(this);

  // JSON parsing helpers
  static int _parseInt(dynamic value) {
    if (value is String) return int.tryParse(value) ?? 0;
    return (value as num?)?.toInt() ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is String) return double.tryParse(value) ?? 0.0;
    return (value as num?)?.toDouble() ?? 0.0;
  }

  static bool _parseBool(dynamic value) {
    if (value is String) return value.toLowerCase() == 'true';
    return value as bool? ?? false;
  }

  Quest toEntity() => Quest(
        id: id,
        title: title,
        description: description,
        category: category,
        points: points,
        durationMinutes: durationMinutes,
        instructions: instructions,
        difficulty: difficulty,
        image: imageUrl,
        isCompleted: isCompleted,
        progress: progress,
      );
}
