import 'package:json_annotation/json_annotation.dart';
import 'package:mental_health_partner/core/utils/date_time_converter.dart';
import 'package:mental_health_partner/domain/entities/user_streak.dart';

part 'user_streak_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserStreakModel extends UserStreak {
  @SafeDateTimeConverter()
  @override
  final DateTime? lastCompletionDate;

  const UserStreakModel({
    required super.currentStreak,
    required super.longestStreak,
    this.lastCompletionDate,
    required super.completedToday,
    required super.daysUntilNextLevel,
    required super.nextLevelName,
  });

  factory UserStreakModel.fromJson(Map<String, dynamic> json) =>
      _$UserStreakModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStreakModelToJson(this);

  UserStreak toEntity() {
    return UserStreak(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastCompletionDate: lastCompletionDate,
      completedToday: completedToday,
      daysUntilNextLevel: daysUntilNextLevel,
      nextLevelName: nextLevelName,
    );
  }
}
