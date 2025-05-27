// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestModel _$QuestModelFromJson(Map<String, dynamic> json) => QuestModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      points: QuestModel._parseInt(json['points']),
      durationMinutes: QuestModel._parseInt(json['duration_minutes']),
      instructions: json['instructions'] as String,
      difficulty: QuestModel._parseInt(json['difficulty']),
      isCompleted: QuestModel._parseBool(json['is_completed']),
      progress: QuestModel._parseDouble(json['progress']),
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$QuestModelToJson(QuestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'points': instance.points,
      'duration_minutes': instance.durationMinutes,
      'instructions': instance.instructions,
      'difficulty': instance.difficulty,
      'image_url': instance.imageUrl,
      'is_completed': instance.isCompleted,
      'progress': instance.progress,
    };
