import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health_partner/config/environment.dart';
import 'package:mental_health_partner/core/storage/secure_storage.dart';
import 'package:mental_health_partner/data/datasources/local/analytics_local_data_source.dart';
import 'package:mental_health_partner/domain/repositories/level_repository.dart';
import 'package:mental_health_partner/domain/usecases/analytics/get_community_engagement.dart';
import 'package:mental_health_partner/domain/usecases/auth/forgot_password_use_case.dart';
import 'package:mental_health_partner/domain/usecases/auth/reset_password_use_case.dart';
import 'package:mental_health_partner/domain/usecases/community/complete_challenge_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/create_success_story_usecase.dart';
import 'package:mental_health_partner/domain/usecases/gamification/get_completed_quest_dates_usecase.dart';
import 'package:mental_health_partner/domain/usecases/gamification/get_user_streak_usecase.dart';
import 'package:mental_health_partner/presentation/blocs/profile/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_partner/data/repositories/profile_repository_impl.dart'
    as profile_repo_impl;
import 'package:mental_health_partner/domain/repositories/profile_repository.dart';

// Core
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/storage/local_storage.dart';
// Auth Feature
import '../data/datasources/local/auth_local_data_source.dart';
import '../data/datasources/remote/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/auth/login_usecase.dart';
import '../domain/usecases/auth/register_usecase.dart';
import '../domain/usecases/auth/logout_usecase.dart';
import '../domain/usecases/auth/get_user_usecase.dart';
import '../presentation/blocs/auth/auth_bloc.dart';

// Mood Feature
import '../data/datasources/local/mood_local_data_source.dart'; // Add this import
import '../data/datasources/remote/mood_remote_data_source.dart';
import '../data/repositories/mood_repository_impl.dart';
import '../domain/repositories/mood_repository.dart';
import '../domain/usecases/mood/record_mood_usecase.dart';
import '../domain/usecases/mood/get_mood_history_usecase.dart';
import '../presentation/blocs/mood/mood_bloc.dart';

// Journal Feature
import '../domain/usecases/journal/add_journal_entry_usecase.dart';
import '../domain/usecases/journal/delete_journal_entry_usecase.dart';
import '../domain/usecases/journal/get_journal_entries_usecase.dart';
import '../presentation/blocs/journal/journal_bloc.dart';

// Analytics Feature
import '../data/datasources/remote/analytics_remote_data_source.dart';
import '../data/repositories/analytics_repository_impl.dart';
import '../domain/repositories/analytics_repository.dart';
import '../domain/usecases/analytics/get_user_activity_usecase.dart';
import '../domain/usecases/mood/get_mood_analytics_usecase.dart';
import '../presentation/blocs/analytics/analytics_bloc.dart';

// Conversation Feature
import '../presentation/blocs/conversation/conversation_bloc.dart';
import '../domain/usecases/conversation/get_conversation_history_usecase.dart';
import '../domain/usecases/conversation/send_message_usecase.dart';
import '../domain/usecases/conversation/start_conversation_usecase.dart';
import '../domain/repositories/conversation_repository.dart';
import '../data/repositories/conversation_repository_impl.dart';
import '../data/datasources/remote/conversation_remote_data_source.dart';
import '../data/datasources/local/conversation_local_data_source.dart';

// Add these new imports for journal feature
import '../data/datasources/local/journal_local_data_source.dart';
import '../data/datasources/remote/journal_remote_data_source.dart';
import '../data/repositories/journal_repository_impl.dart';
import '../domain/repositories/journal_repository.dart';

// Add these new imports for gamification feature
import '../data/datasources/local/gamification_local_data_source.dart';
import '../data/datasources/remote/gamification_remote_data_source.dart';
import '../data/repositories/gamification_repository_impl.dart';
import '../domain/repositories/gamification_repository.dart';
import '../domain/usecases/gamification/complete_quest_usecase.dart';
import '../domain/usecases/gamification/get_achievements_usecase.dart';
import '../domain/usecases/gamification/get_earned_achievements_usecase.dart';
import '../domain/usecases/gamification/get_quests_usecase.dart';
import '../domain/usecases/gamification/get_recommended_quests_usecase.dart';
import '../domain/usecases/gamification/get_redeemed_rewards_usecase.dart';
import '../domain/usecases/gamification/get_rewards_usecase.dart';
import '../domain/usecases/gamification/get_user_points_usecase.dart';
import '../domain/usecases/gamification/redeem_reward_usecase.dart';
import '../domain/usecases/gamification/start_quest_usecase.dart';
import '../presentation/blocs/gamification/gamification_bloc.dart';

// Community Feature
import '../data/datasources/local/community_local_data_source.dart';
import '../data/datasources/remote/community_remote_data_source.dart';
import '../data/repositories/community_repository_impl.dart';
import '../domain/repositories/community_repository.dart';
import '../domain/usecases/community/create_forum_post_usecase.dart';
import '../domain/usecases/community/get_challenges_usecase.dart';
import '../domain/usecases/community/get_discussion_groups_usecase.dart';
import '../domain/usecases/community/get_forum_threads_usecase.dart';
import '../domain/usecases/community/get_success_stories_usecase.dart';
import '../domain/usecases/community/join_challenge_usecase.dart';
import '../domain/usecases/community/join_discussion_group_usecase.dart';
import '../domain/usecases/community/send_encouragement_usecase.dart';
import '../presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/domain/usecases/community/get_thread_details_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
// ========================== Core ==========================

// Initialize Environment first (Important!)
  await Environment.init();

// Register baseUrl dynamically based on Environment
  sl.registerLazySingleton<String>(
    () => Environment.apiBaseUrl,
    instanceName: 'baseUrl',
  );

// Core services
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker(),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());

  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

// SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

// Local Storage
  final localStorage = LocalStorage();
  await localStorage.init();
  sl.registerLazySingleton<LocalStorage>(() => localStorage);

// API Client
  sl.registerLazySingleton<ApiClient>(() => ApiClient(
        secureStorage: sl<SecureStorage>(),
        networkInfo: sl<NetworkInfo>(),
      ));
  sl.registerLazySingleton<Dio>(() => sl<ApiClient>().dio);

// Conversation Remote Data Source
  sl.registerLazySingleton<ConversationRemoteDataSource>(
    () => ConversationRemoteDataSourceImpl(
      dio: sl<Dio>(),
      prefs: sl<SharedPreferences>(),
    ),
  );

// ========================== Auth Feature ==========================
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        getUserUseCase: sl<GetUserUseCase>(),
        forgotPasswordUseCase:
            sl<ForgotPasswordUseCase>(), // Fixed: use service locator
        resetPasswordUseCase:
            sl<ResetPasswordUseCase>(), // Fixed: use service locator
      ));

  sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<GetUserUseCase>(
      () => GetUserUseCase(sl<AuthRepository>()));

// Add these missing registrations
  sl.registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        localDataSource: sl<AuthLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl<ApiClient>()));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
        secureStorage: sl<SecureStorage>(),
        localStorage: sl<LocalStorage>(),
      ));
  // ========================== Profile Feature ==========================
// Add after AuthBloc registration but before other feature registrations
  sl.registerLazySingleton<ProfileRepository>(
    () => profile_repo_impl.ProfileRepositoryImpl(
      client: sl<ApiClient>(),
      localStorage: sl<LocalStorage>(),
    ),
  );

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      profileRepository: sl<ProfileRepository>(),
      authBloc: sl<AuthBloc>(), // Ensure AuthBloc is registered first
    ),
  );
  // ========================== Mood Feature ==========================
  sl.registerFactory<MoodBloc>(() => MoodBloc(
        recordMood: sl<RecordMoodUseCase>(),
        getHistory: sl<GetMoodHistoryUseCase>(),
      ));

  sl.registerLazySingleton<RecordMoodUseCase>(
      () => RecordMoodUseCase(sl<MoodRepository>()));
  sl.registerLazySingleton<GetMoodHistoryUseCase>(
      () => GetMoodHistoryUseCase(sl<MoodRepository>()));

  // Add MoodLocalDataSource registration
  sl.registerLazySingleton<MoodLocalDataSource>(
      () => MoodLocalDataSourceImpl(localStorage: sl<LocalStorage>()));

  sl.registerLazySingleton<MoodRepository>(() => MoodRepositoryImpl(
        remoteDataSource: sl<MoodRemoteDataSource>(),
        localDataSource: sl<MoodLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));

  sl.registerLazySingleton<MoodRemoteDataSource>(
      () => MoodRemoteDataSourceImpl(client: sl<ApiClient>()));

  // ========================== Journal Feature ==========================
  sl.registerFactory<JournalBloc>(() => JournalBloc(
        getEntries: sl<GetJournalEntriesUseCase>(),
        addEntry: sl<AddJournalEntryUseCase>(),
        deleteEntry: sl<DeleteJournalEntryUseCase>(),
      ));

  sl.registerLazySingleton<AddJournalEntryUseCase>(
      () => AddJournalEntryUseCase(sl<JournalRepository>()));
  sl.registerLazySingleton<GetJournalEntriesUseCase>(
      () => GetJournalEntriesUseCase(sl<JournalRepository>()));
  sl.registerLazySingleton<DeleteJournalEntryUseCase>(
      () => DeleteJournalEntryUseCase(sl<JournalRepository>()));

  sl.registerLazySingleton<JournalRepository>(() => JournalRepositoryImpl(
        remoteDataSource: sl<JournalRemoteDataSource>(),
        localDataSource: sl<JournalLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));

  sl.registerLazySingleton<JournalRemoteDataSource>(
    () => JournalRemoteDataSourceImpl(client: sl<ApiClient>()),
  );

  sl.registerLazySingleton<JournalLocalDataSource>(
    () => JournalLocalDataSourceImpl(localStorage: sl<LocalStorage>()),
  );

// ========================== Analytics Feature ==========================

// BLoC
  sl.registerFactory<AnalyticsBloc>(() => AnalyticsBloc(
        getMoodAnalytics: sl<GetMoodAnalyticsUseCase>(),
        getUserActivity: sl<GetUserActivityUseCase>(),
        getCommunityEngagement: sl<GetCommunityEngagement>(),
      ));

// Use Cases
  sl.registerLazySingleton<GetMoodAnalyticsUseCase>(
      () => GetMoodAnalyticsUseCase(sl<MoodRepository>()));

  sl.registerLazySingleton<GetUserActivityUseCase>(
      () => GetUserActivityUseCase(sl<AnalyticsRepository>()));

  sl.registerLazySingleton<GetCommunityEngagement>(
      () => GetCommunityEngagement(sl<CommunityRepository>()));
// Local Data Source
  sl.registerLazySingleton<AnalyticsLocalDataSource>(
    () => AnalyticsLocalDataSourceImpl(prefs: sl<SharedPreferences>()),
  );

// Repositories
  sl.registerLazySingleton<AnalyticsRepository>(() => AnalyticsRepositoryImpl(
        remoteDataSource: sl<AnalyticsRemoteDataSource>(),
        localDataSource: sl<AnalyticsLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));

// Data Sources
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(
      () => AnalyticsRemoteDataSourceImpl(client: sl<ApiClient>()));

  // ========================== Conversation Feature ==========================
  // Data sources

  sl.registerLazySingleton<ConversationLocalDataSource>(
    () => ConversationLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(
      remoteDataSource: sl<ConversationRemoteDataSource>(),
      localDataSource: sl<ConversationLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetConversations>(
      () => GetConversations(sl<ConversationRepository>()));
  sl.registerLazySingleton<SendMessage>(
      () => SendMessage(sl<ConversationRepository>()));
  sl.registerLazySingleton<StartConversation>(
      () => StartConversation(sl<ConversationRepository>()));

  // BLoC
  sl.registerFactory<ConversationBloc>(() => ConversationBloc(
        getConversations: sl<GetConversations>(),
        sendMessage: sl<SendMessage>(),
        startConversation: sl<StartConversation>(),
      ));

  // ========================== Gamification Feature ==========================

// Bloc
  sl.registerFactory<GamificationBloc>(() => GamificationBloc(
        getQuests: sl<GetQuestsUseCase>(),
        getRecommendedQuests: sl<GetRecommendedQuestsUseCase>(),
        startQuest: sl<StartQuestUseCase>(),
        completeQuest: sl<CompleteQuestUseCase>(),
        getAchievements: sl<GetAchievementsUseCase>(),
        getEarnedAchievements: sl<GetEarnedAchievementsUseCase>(),
        getRewards: sl<GetRewardsUseCase>(),
        getRedeemedRewards: sl<GetRedeemedRewardsUseCase>(),
        redeemReward: sl<RedeemRewardUseCase>(),
        getUserPoints: sl<GetUserPointsUseCase>(),
        authBloc: sl<AuthBloc>(),
        getUserStreak: sl<GetUserStreakUseCase>(), // ✅ Added
        getCompletedQuestDates: sl<GetCompletedQuestDatesUseCase>(), // ✅ Added
        gamificationRepository: sl<GamificationRepository>(), // ✅ NEW
        levelRepository: sl<LevelRepository>(),
      ));

// Use Cases
  sl.registerLazySingleton<GetQuestsUseCase>(
      () => GetQuestsUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<GetRecommendedQuestsUseCase>(
      () => GetRecommendedQuestsUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<StartQuestUseCase>(
      () => StartQuestUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<CompleteQuestUseCase>(
      () => CompleteQuestUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<GetAchievementsUseCase>(
      () => GetAchievementsUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<GetEarnedAchievementsUseCase>(
      () => GetEarnedAchievementsUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<GetRewardsUseCase>(
      () => GetRewardsUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<GetRedeemedRewardsUseCase>(
      () => GetRedeemedRewardsUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<RedeemRewardUseCase>(
      () => RedeemRewardUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<GetUserPointsUseCase>(
      () => GetUserPointsUseCase(sl<GamificationRepository>()));
  sl.registerLazySingleton<GetUserStreakUseCase>(
      () => GetUserStreakUseCase(sl<GamificationRepository>()));

  sl.registerLazySingleton<GetCompletedQuestDatesUseCase>(
      () => GetCompletedQuestDatesUseCase(sl<GamificationRepository>()));

// Repository
  sl.registerLazySingleton<GamificationRepository>(
      () => GamificationRepositoryImpl(
            remoteDataSource: sl<GamificationRemoteDataSource>(),
            localDataSource: sl<GamificationLocalDataSource>(),
            networkInfo: sl<NetworkInfo>(),
          ));

// Data Sources
  sl.registerLazySingleton<GamificationRemoteDataSource>(
    () => GamificationRemoteDataSourceImpl(
      client: sl<http.Client>(),
      baseUrl: sl<String>(instanceName: 'baseUrl'),
      authLocalDataSource: sl<AuthLocalDataSource>(), // Updated here
    ),
  );

  sl.registerLazySingleton<GamificationLocalDataSource>(
    () => GamificationLocalDataSourceImpl(
      sl<SharedPreferences>(),
      storage: sl<LocalStorage>(),
    ),
  );
  // ========================== Community Feature ==========================
  sl.registerFactory<CommunityBloc>(() => CommunityBloc(
        getDiscussionGroups: sl<GetDiscussionGroupsUseCase>(),
        joinDiscussionGroup: sl<JoinDiscussionGroupUseCase>(),
        getForumThreads: sl<GetForumThreadsUseCase>(),
        createForumPost: sl<CreateForumPostUseCase>(),
        getChallenges: sl<GetChallengesUseCase>(),
        joinChallenge: sl<JoinChallengeUseCase>(),
        getSuccessStories: sl<GetSuccessStoriesUseCase>(),
        sendEncouragement: sl<SendEncouragementUseCase>(),
        getThreadDetails: sl<GetThreadDetailsUseCase>(),
        completeChallenge: sl<CompleteChallengeUseCase>(),
        createSuccessStory: sl<CreateSuccessStoryUseCase>(), // ✅ Add this line
      ));

// Use Cases
  sl.registerLazySingleton<GetDiscussionGroupsUseCase>(
      () => GetDiscussionGroupsUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<JoinDiscussionGroupUseCase>(
      () => JoinDiscussionGroupUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<GetForumThreadsUseCase>(
      () => GetForumThreadsUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<CreateForumPostUseCase>(
      () => CreateForumPostUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<GetChallengesUseCase>(
      () => GetChallengesUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<JoinChallengeUseCase>(
      () => JoinChallengeUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<GetSuccessStoriesUseCase>(
      () => GetSuccessStoriesUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<SendEncouragementUseCase>(
      () => SendEncouragementUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<GetThreadDetailsUseCase>(
      () => GetThreadDetailsUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<CompleteChallengeUseCase>(
      () => CompleteChallengeUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<CreateSuccessStoryUseCase>(
      () => CreateSuccessStoryUseCase(sl<CommunityRepository>()));
  sl.registerLazySingleton<LevelRepository>(() => LevelRepository());

// Repository and Data Sources
  sl.registerLazySingleton<CommunityRepository>(() => CommunityRepositoryImpl(
        remoteDataSource: sl<CommunityRemoteDataSource>(),
        localDataSource: sl<CommunityLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));
  sl.registerLazySingleton<CommunityLocalDataSource>(
      () => CommunityLocalDataSourceImpl(localStorage: sl<LocalStorage>()));
  sl.registerLazySingleton<CommunityRemoteDataSource>(
      () => CommunityRemoteDataSourceImpl(client: sl<ApiClient>()));
}
