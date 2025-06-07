part of 'gamification_bloc.dart';

abstract class GamificationEvent extends Equatable {
  const GamificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuests extends GamificationEvent {}

class LoadRecommendedQuests extends GamificationEvent {}

class StartQuestEvent extends GamificationEvent {
  final int questId;
  final int? moodBefore;

  const StartQuestEvent({
    required this.questId,
    this.moodBefore,
  });

  @override
  List<Object?> get props => [questId, moodBefore];
}

class AddPoints extends GamificationEvent {
  final int points;

  const AddPoints({required this.points});

  @override
  List<Object> get props => [points];
}

class CompleteQuestEvent extends GamificationEvent {
  final int userQuestId;
  final String? reflection;
  final int? moodAfter;

  const CompleteQuestEvent({
    required this.userQuestId,
    this.reflection,
    this.moodAfter,
  });

  @override
  List<Object?> get props => [userQuestId, reflection, moodAfter];
}

class LoadAchievements extends GamificationEvent {}

class LoadEarnedAchievements extends GamificationEvent {}

class LoadRewards extends GamificationEvent {}

class LoadRedeemedRewards extends GamificationEvent {}

class RedeemRewardEvent extends GamificationEvent {
  final int rewardId;

  const RedeemRewardEvent({required this.rewardId});

  @override
  List<Object> get props => [rewardId];
}

// Streak events - NEW
class LoadUserStreak extends GamificationEvent {}

class UpdateStreakAfterQuestCompletion extends GamificationEvent {
  final DateTime completionDate;

  const UpdateStreakAfterQuestCompletion({
    required this.completionDate,
  });

  @override
  List<Object> get props => [completionDate];
}

class LoadUserPoints extends GamificationEvent {}

class CheckLevelUpEvent extends GamificationEvent {
  final int oldPoints;
  final int newPoints;

  const CheckLevelUpEvent({
    required this.oldPoints,
    required this.newPoints,
  });

  @override
  List<Object> get props => [oldPoints, newPoints];
}

class LoadUserLevelEvent extends GamificationEvent {}

class AcknowledgeLevelUpEvent extends GamificationEvent {}
