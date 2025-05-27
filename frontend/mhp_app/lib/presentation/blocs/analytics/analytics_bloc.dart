import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/usecases/analytics/get_community_engagement.dart';
import 'package:mental_health_partner/domain/usecases/analytics/get_user_activity_usecase.dart';
import 'package:mental_health_partner/domain/usecases/mood/get_mood_analytics_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetMoodAnalyticsUseCase getMoodAnalytics;
  final GetUserActivityUseCase getUserActivity;
  final GetCommunityEngagement getCommunityEngagement;

  AnalyticsBloc({
    required this.getMoodAnalytics,
    required this.getUserActivity,
    required this.getCommunityEngagement,
  }) : super(AnalyticsInitial()) {
    on<LoadMoodAnalytics>(_onLoadMoodAnalytics);
    on<LoadUserActivity>(_onLoadUserActivity);
    on<LoadCommunityEngagement>(_onLoadCommunityEngagement);
  }

  Future<void> _onLoadMoodAnalytics(
    LoadMoodAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    if (state is! MoodAnalyticsLoaded) {
      emit(AnalyticsLoading());
    }

    final result = await getMoodAnalytics();
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (analytics) => emit(MoodAnalyticsLoaded(
        analytics: analytics,
        history: [], // <- fix: added default empty history
      )),
    );
  }

  Future<void> _onLoadUserActivity(
    LoadUserActivity event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Don't emit loading if we've already loaded the data
    if (state is! UserActivityLoaded) {
      emit(AnalyticsLoading());
    }

    final result = await getUserActivity();
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (activity) => emit(UserActivityLoaded(activity)),
    );
  }

  void _onLoadCommunityEngagement(
    LoadCommunityEngagement event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getCommunityEngagement(NoParams());
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (engagement) => emit(CommunityEngagementLoaded(
        activeDiscussions: engagement.activeDiscussions,
        challengesCompleted: engagement.challengesCompleted,
        forumPosts: engagement.forumPosts,
        successStories: engagement.successStories,
      )),
    );
  }
}
