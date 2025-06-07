import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/entities/user_level.dart';
import 'package:mental_health_partner/domain/entities/user_points.dart';
import 'package:mental_health_partner/domain/entities/user_progress.dart';
import 'package:mental_health_partner/domain/entities/user_streak.dart';
import 'package:mental_health_partner/domain/repositories/gamification_repository.dart';
import 'package:mental_health_partner/domain/repositories/level_repository.dart';
import 'package:mental_health_partner/domain/usecases/gamification/get_completed_quest_dates_usecase.dart';
import 'package:mental_health_partner/domain/usecases/gamification/get_user_streak_usecase.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_event.dart';
import '../../../domain/entities/quest.dart';
import '../../../domain/entities/achievement.dart';
import '../../../domain/entities/reward.dart';
import '../../../domain/usecases/gamification/get_quests_usecase.dart';
import '../../../domain/usecases/gamification/get_recommended_quests_usecase.dart';
import '../../../domain/usecases/gamification/start_quest_usecase.dart';
import '../../../domain/usecases/gamification/complete_quest_usecase.dart';
import '../../../domain/usecases/gamification/get_achievements_usecase.dart';
import '../../../domain/usecases/gamification/get_earned_achievements_usecase.dart';
import '../../../domain/usecases/gamification/get_rewards_usecase.dart';
import '../../../domain/usecases/gamification/get_redeemed_rewards_usecase.dart';
import '../../../domain/usecases/gamification/redeem_reward_usecase.dart';
import '../../../domain/usecases/gamification/get_user_points_usecase.dart';
import '../../../../core/usecases/usecase.dart';

part 'gamification_event.dart';
part 'gamification_state.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  final GetQuestsUseCase getQuests;
  final GetRecommendedQuestsUseCase getRecommendedQuests;
  final StartQuestUseCase startQuest;
  final CompleteQuestUseCase completeQuest;
  final GetAchievementsUseCase getAchievements;
  final GetEarnedAchievementsUseCase getEarnedAchievements;
  final GetRewardsUseCase getRewards;
  final GetRedeemedRewardsUseCase getRedeemedRewards;
  final RedeemRewardUseCase redeemReward;
  final GetUserPointsUseCase getUserPoints;
  final AuthBloc authBloc;

  final GetUserStreakUseCase getUserStreak;
  final GetCompletedQuestDatesUseCase getCompletedQuestDates;

  //final GamificationRepository _gamificationRepository;
  final LevelRepository _levelRepository;

  GamificationBloc({
    required this.getQuests,
    required this.getRecommendedQuests,
    required this.startQuest,
    required this.completeQuest,
    required this.getAchievements,
    required this.getEarnedAchievements,
    required this.getRewards,
    required this.getRedeemedRewards,
    required this.redeemReward,
    required this.getUserPoints,
    required this.authBloc,
    required this.getUserStreak,
    required this.getCompletedQuestDates,
    required GamificationRepository gamificationRepository,
    required LevelRepository levelRepository,
  })  : _levelRepository = levelRepository,
        super(GamificationInitial()) {
    on<LoadQuests>(_onLoadQuests);
    on<LoadRecommendedQuests>(_onLoadRecommendedQuests);
    on<StartQuestEvent>(_onStartQuest);
    on<CompleteQuestEvent>(_onCompleteQuest);
    on<LoadAchievements>(_onLoadAchievements);
    on<LoadEarnedAchievements>(_onLoadEarnedAchievements);
    on<LoadRewards>(_onLoadRewards);
    on<LoadRedeemedRewards>(_onLoadRedeemedRewards);
    on<RedeemRewardEvent>(_onRedeemReward);
    on<LoadUserPoints>(_onLoadUserPoints);
    on<AddPoints>(_onAddPoints);

    on<LoadUserStreak>(_onLoadUserStreak);
    on<UpdateStreakAfterQuestCompletion>(_onUpdateStreakAfterQuestCompletion);
    on<CheckLevelUpEvent>(_onCheckLevelUp);
    // on<LoadUserLevelEvent>(_onLoadUserLevel);
    // on<AcknowledgeLevelUpEvent>(_onAcknowledgeLevelUp);
  }

  void _onAddPoints(AddPoints event, Emitter<GamificationState> emit) {
    final currentState = state;
    if (currentState is PointsLoaded) {
      emit(PointsLoaded(UserPoints(
        totalPoints: currentState.points.totalPoints + event.points,
        currentPoints: currentState.points.currentPoints + event.points,
        lastUpdated: DateTime.now(),
      )));
    }
  }

  Future<void> _onLoadQuests(
      LoadQuests event, Emitter<GamificationState> emit) async {
    emit(QuestsLoading());
    final result = await getQuests(NoParams());
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(QuestsError(_mapFailureToMessage(failure)));
      },
      (quests) => emit(QuestsLoaded(quests)),
    );
  }

  Future<void> _onLoadRecommendedQuests(
      LoadRecommendedQuests event, Emitter<GamificationState> emit) async {
    emit(RecommendedQuestsLoading());
    try {
      final result = await getRecommendedQuests(NoParams());
      result.fold(
        (failure) {
          // Debug logging
          print(
              'Recommended quests error: ${failure.runtimeType}: ${failure.toString()}');
          _handleAuthFailure(failure);
          emit(RecommendedQuestsError(_mapFailureToMessage(failure)));
        },
        (quests) {
          // Debug logging
          print('Loaded ${quests.length} recommended quests successfully');
          emit(RecommendedQuestsLoaded(quests));
        },
      );
    } catch (e) {
      // Additional error handling for unexpected exceptions
      print('Unexpected error in _onLoadRecommendedQuests: $e');
      emit(const RecommendedQuestsError(
          'An unexpected error occurred. Please try again later.'));
    }
  }

  Future<void> _onStartQuest(
      StartQuestEvent event, Emitter<GamificationState> emit) async {
    emit(StartingQuest());
    final result = await startQuest(StartQuestParams(
      questId: event.questId,
      moodBefore: event.moodBefore,
    ));
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(StartQuestError(_mapFailureToMessage(failure)));
      },
      (userQuest) => emit(QuestStarted(userQuest)),
    );
  }

  Future<void> _onCompleteQuest(
      CompleteQuestEvent event, Emitter<GamificationState> emit) async {
    emit(CompletingQuest());
    final result = await completeQuest(CompleteQuestParams(
      userQuestId: event.userQuestId,
      reflection: event.reflection,
      moodAfter: event.moodAfter,
    ));
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(CompleteQuestError(_mapFailureToMessage(failure)));
      },
      (data) {
        emit(QuestCompleted(
          pointsEarned: data['points_earned'],
          totalPoints: data['total_points'],
          currentPoints: data['current_points'],
        ));
        // Trigger streak update after quest completion
        add(UpdateStreakAfterQuestCompletion(
          completionDate: DateTime.now(),
        ));
      },
    );
  }

  Future<void> _onLoadUserStreak(
      LoadUserStreak event, Emitter<GamificationState> emit) async {
    emit(StreakLoading());
    final result = await getUserStreak(NoParams());
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(StreakError(_mapFailureToMessage(failure)));
      },
      (streak) => emit(StreakLoaded(streak)),
    );
  }

  Future<void> _onUpdateStreakAfterQuestCompletion(
      UpdateStreakAfterQuestCompletion event,
      Emitter<GamificationState> emit) async {
    // Reload streak data after quest completion
    add(LoadUserStreak());
  }

  Future<void> _onLoadAchievements(
      LoadAchievements event, Emitter<GamificationState> emit) async {
    emit(AchievementsLoading());
    final result = await getAchievements(NoParams());
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(AchievementsError(_mapFailureToMessage(failure)));
      },
      (achievements) => emit(AchievementsLoaded(achievements)),
    );
  }

  Future<void> _onLoadEarnedAchievements(
      LoadEarnedAchievements event, Emitter<GamificationState> emit) async {
    emit(EarnedAchievementsLoading());
    final result = await getEarnedAchievements(NoParams());
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(EarnedAchievementsError(_mapFailureToMessage(failure)));
      },
      (achievements) => emit(EarnedAchievementsLoaded(achievements)),
    );
  }

  Future<void> _onLoadRewards(
      LoadRewards event, Emitter<GamificationState> emit) async {
    emit(RewardsLoading());
    final result = await getRewards(NoParams());
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(RewardsError(_mapFailureToMessage(failure)));
      },
      (rewards) => emit(RewardsLoaded(rewards)),
    );
  }

  Future<void> _onLoadRedeemedRewards(
      LoadRedeemedRewards event, Emitter<GamificationState> emit) async {
    emit(RedeemedRewardsLoading());
    final result = await getRedeemedRewards(NoParams());
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(RedeemedRewardsError(_mapFailureToMessage(failure)));
      },
      (rewards) => emit(RedeemedRewardsLoaded(rewards)),
    );
  }

  Future<void> _onRedeemReward(
      RedeemRewardEvent event, Emitter<GamificationState> emit) async {
    emit(RedeemingReward());
    final result =
        await redeemReward(RedeemRewardParams(rewardId: event.rewardId));
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(RedeemRewardError(_mapFailureToMessage(failure)));
      },
      (userReward) => emit(RewardRedeemed(userReward)),
    );
  }

  Future<void> _onLoadUserPoints(
      LoadUserPoints event, Emitter<GamificationState> emit) async {
    emit(PointsLoading());
    final result = await getUserPoints(NoParams());
    result.fold(
      (failure) {
        _handleAuthFailure(failure);
        emit(PointsError(_mapFailureToMessage(failure)));
      },
      (points) => emit(PointsLoaded(points)),
    );
  }

  void _handleAuthFailure(Failure failure) {
    if (failure is AuthFailure) {
      authBloc.add(const LogoutRequested()); // Remove context parameter
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error. Please try again later.';
      case CacheFailure:
        return 'Cached data not available.';
      case NetworkFailure:
        return 'No internet connection. Please check your connection and try again.';
      case AuthFailure:
        return 'Session expired. Please log in again.';
      default:
        return 'Unexpected error. Please try again later.';
    }
  }

  Future<void> _onCheckLevelUp(
    CheckLevelUpEvent event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      final oldLevel = _levelRepository.getLevelByPoints(event.oldPoints);
      final newLevel = _levelRepository.getLevelByPoints(event.newPoints);

      if (newLevel.level > oldLevel.level) {
        emit(LevelUpState(newLevel: newLevel));
      }
    } catch (e) {
      // Handle error silently as this is a background check
    }
  }

  // Future<void> _onLoadUserLevel(
  //   LoadUserLevelEvent event,
  //   Emitter<GamificationState> emit,
  // ) async {
  //   try {
  //     emit(GamificationLoading());

  //     final points = await _gamificationRepository.getUserPoints();
  //     final userProgress =
  //         _levelRepository.getUserProgress(points.currentPoints);

  //     emit(UserLevelLoaded(userProgress: userProgress));
  //   } catch (e) {
  //     emit(UserLevelError(message: e.toString()));
  //   }
  // }

  // Future<void> _onAcknowledgeLevelUp(
  //   AcknowledgeLevelUpEvent event,
  //   Emitter<GamificationState> emit,
  // ) async {
  //   // Return to previous state or load current data
  //   add(LoadUserPoints());
  // }

  // // Override the points loading to check for level ups
  // Future<void> _onLoadUserPoints(
  //   LoadUserPoints event,
  //   Emitter<GamificationState> emit,
  // ) async {
  //   try {
  //     emit(GamificationLoading());

  //     // Get old points if available
  //     int oldPoints = 0;
  //     if (state is PointsLoaded) {
  //       oldPoints = (state as PointsLoaded).points.currentPoints;
  //     }

  //     final points = await _gamificationRepository.getUserPoints();
  //     emit(PointsLoaded(points: points));

  //     // Check for level up
  //     if (oldPoints > 0 && points.currentPoints > oldPoints) {
  //       add(CheckLevelUpEvent(
  //           oldPoints: oldPoints, newPoints: points.currentPoints));
  //     }
  //   } catch (e) {
  //     emit(PointsError(message: e.toString()));
  //   }
  // }
}
