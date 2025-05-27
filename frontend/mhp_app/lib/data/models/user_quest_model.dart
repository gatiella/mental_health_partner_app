import 'package:json_annotation/json_annotation.dart';
import 'package:mental_health_partner/data/models/quest_model.dart';
import 'package:mental_health_partner/domain/entities/quest.dart';

part 'user_quest_model.g.dart';

@JsonSerializable()
class UserQuestModel {
  final int id;

  @JsonKey(name: 'quest')
  final QuestModel quest;

  @JsonKey(name: 'started_at')
  final DateTime startedAt;

  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @JsonKey(name: 'is_completed')
  final bool isCompleted;

  final String? reflection;

  @JsonKey(name: 'mood_before')
  final int? moodBefore;

  @JsonKey(name: 'mood_after')
  final int? moodAfter;

  UserQuestModel({
    required this.id,
    required this.quest,
    required this.startedAt,
    this.completedAt,
    required this.isCompleted,
    this.reflection,
    this.moodBefore,
    this.moodAfter,
  });

  factory UserQuestModel.fromJson(Map<String, dynamic> json) =>
      _$UserQuestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserQuestModelToJson(this);

  UserQuest toEntity() => UserQuest(
        id: id,
        quest: quest.toEntity(),
        startedAt: startedAt,
        completedAt: completedAt,
        isCompleted: isCompleted,
        reflection: reflection,
        moodBefore: moodBefore,
        moodAfter: moodAfter,
      );
}
