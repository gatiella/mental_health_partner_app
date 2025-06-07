part of 'gamification_bloc.dart';

abstract class GamificationState extends Equatable {
  const GamificationState();

  @override
  List<Object?> get props => [];
}

class GamificationInitial extends GamificationState {}

// Quest states
class QuestsLoading extends GamificationState {}

class QuestsLoaded extends GamificationState {
  final List<Quest> quests;

  const QuestsLoaded(this.quests);

  @override
  List<Object> get props => [quests];
}

class QuestsError extends GamificationState {
  final String message;

  const QuestsError(this.message);

  @override
  List<Object> get props => [message];
}

// Streak states - NEW
class StreakLoading extends GamificationState {}

class StreakLoaded extends GamificationState {
  final UserStreak streak;

  const StreakLoaded(this.streak);

  @override
  List<Object> get props => [streak];
}

class StreakError extends GamificationState {
  final String message;

  const StreakError(this.message);

  @override
  List<Object> get props => [message];
}

// Recommended Quest states
class RecommendedQuestsLoading extends GamificationState {}

class RecommendedQuestsLoaded extends GamificationState {
  final List<Quest> quests;

  const RecommendedQuestsLoaded(this.quests);

  @override
  List<Object> get props => [quests];
}

class RecommendedQuestsError extends GamificationState {
  final String message;

  const RecommendedQuestsError(this.message);

  @override
  List<Object> get props => [message];
}

// Start Quest states
class StartingQuest extends GamificationState {}

class QuestStarted extends GamificationState {
  final UserQuest userQuest;

  const QuestStarted(this.userQuest);

  @override
  List<Object> get props => [userQuest];
}

class StartQuestError extends GamificationState {
  final String message;

  const StartQuestError(this.message);

  @override
  List<Object> get props => [message];
}

// Complete Quest states
class CompletingQuest extends GamificationState {}

class QuestCompleted extends GamificationState {
  final int pointsEarned;
  final int totalPoints;
  final int currentPoints;

  const QuestCompleted({
    required this.pointsEarned,
    required this.totalPoints,
    required this.currentPoints,
  });

  @override
  List<Object> get props => [pointsEarned, totalPoints, currentPoints];
}

class CompleteQuestError extends GamificationState {
  final String message;

  const CompleteQuestError(this.message);

  @override
  List<Object> get props => [message];
}

// Achievement states
class AchievementsLoading extends GamificationState {}

class AchievementsLoaded extends GamificationState {
  final List<Achievement> achievements;

  const AchievementsLoaded(this.achievements);

  @override
  List<Object> get props => [achievements];
}

class AchievementsError extends GamificationState {
  final String message;

  const AchievementsError(this.message);

  @override
  List<Object> get props => [message];
}

// Earned Achievement states
class EarnedAchievementsLoading extends GamificationState {}

class EarnedAchievementsLoaded extends GamificationState {
  final List<UserAchievement> achievements;

  const EarnedAchievementsLoaded(this.achievements);

  @override
  List<Object> get props => [achievements];
}

class EarnedAchievementsError extends GamificationState {
  final String message;

  const EarnedAchievementsError(this.message);

  @override
  List<Object> get props => [message];
}

// Reward states
class RewardsLoading extends GamificationState {}

class RewardsLoaded extends GamificationState {
  final List<Reward> rewards;

  const RewardsLoaded(this.rewards);

  @override
  List<Object> get props => [rewards];
}

class RewardsError extends GamificationState {
  final String message;

  const RewardsError(this.message);

  @override
  List<Object> get props => [message];
}

// Redeemed Reward states
class RedeemedRewardsLoading extends GamificationState {}

class RedeemedRewardsLoaded extends GamificationState {
  final List<UserReward> rewards;

  const RedeemedRewardsLoaded(this.rewards);

  @override
  List<Object> get props => [rewards];
}

class RedeemedRewardsError extends GamificationState {
  final String message;

  const RedeemedRewardsError(this.message);

  @override
  List<Object> get props => [message];
}

// Redeem Reward states
class RedeemingReward extends GamificationState {}

class RewardRedeemed extends GamificationState {
  final UserReward userReward;

  const RewardRedeemed(this.userReward);

  @override
  List<Object> get props => [userReward];
}

class RedeemRewardError extends GamificationState {
  final String message;

  const RedeemRewardError(this.message);

  @override
  List<Object> get props => [message];
}

// User Points states
class PointsLoading extends GamificationState {}

class PointsLoaded extends GamificationState {
  final UserPoints points;

  const PointsLoaded(this.points);

  @override
  List<Object> get props => [points];
}

class PointsError extends GamificationState {
  final String message;

  const PointsError(this.message);

  @override
  List<Object> get props => [message];
}

class LevelUpState extends GamificationState {
  final UserLevel newLevel;

  const LevelUpState({required this.newLevel});

  @override
  List<Object> get props => [newLevel];
}

class UserLevelLoaded extends GamificationState {
  final UserProgress userProgress;

  const UserLevelLoaded({required this.userProgress});

  @override
  List<Object> get props => [userProgress];
}

class UserLevelError extends GamificationState {
  final String message;

  const UserLevelError({required this.message});

  @override
  List<Object> get props => [message];
}
