// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_quest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserQuestModel _$UserQuestModelFromJson(Map<String, dynamic> json) =>
    UserQuestModel(
      id: (json['id'] as num).toInt(),
      quest: QuestModel.fromJson(json['quest'] as Map<String, dynamic>),
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      isCompleted: json['is_completed'] as bool,
      reflection: json['reflection'] as String?,
      moodBefore: (json['mood_before'] as num?)?.toInt(),
      moodAfter: (json['mood_after'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserQuestModelToJson(UserQuestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quest': instance.quest,
      'started_at': instance.startedAt.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'is_completed': instance.isCompleted,
      'reflection': instance.reflection,
      'mood_before': instance.moodBefore,
      'mood_after': instance.moodAfter,
    };
