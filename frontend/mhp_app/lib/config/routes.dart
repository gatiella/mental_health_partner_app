import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/di/injection_container.dart';
import 'package:mental_health_partner/domain/entities/community_challenge.dart';
import 'package:mental_health_partner/presentation/blocs/analytics/analytics_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/analytics/analytics_event.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/blocs/gamification/gamification_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_event.dart';
import 'package:mental_health_partner/presentation/pages/analytics/dashboard_page.dart';
import 'package:mental_health_partner/presentation/pages/community/challenge_detail_page.dart';
import 'package:mental_health_partner/presentation/pages/community/challenges_page.dart';
import 'package:mental_health_partner/presentation/pages/community/discussion_group_page.dart';
import 'package:mental_health_partner/presentation/pages/community/discussion_groups_list_page.dart';
import 'package:mental_health_partner/presentation/pages/community/forum_thread_detail_page.dart';
import 'package:mental_health_partner/presentation/pages/community/forums_list_page.dart';
import 'package:mental_health_partner/presentation/pages/community/success_stories_page.dart';
import 'package:mental_health_partner/presentation/pages/gamification/achievements_page.dart';
import 'package:mental_health_partner/presentation/pages/gamification/gamification_dashboard.dart';
import 'package:mental_health_partner/presentation/pages/gamification/levels_page.dart';
import 'package:mental_health_partner/presentation/pages/gamification/quests_page.dart';
import 'package:mental_health_partner/presentation/pages/gamification/rewards_page.dart';
import '../presentation/pages/splash/splash_screen.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/conversation/conversation_page.dart';
import '../presentation/pages/conversation/start_conversation_page.dart';
import '../presentation/pages/conversation/conversation_history_page.dart';
import '../presentation/pages/journal/journal_list_page.dart';
import '../presentation/pages/journal/add_journal_page.dart';
import '../presentation/pages/journal/journal_detail_page.dart';
import '../presentation/pages/mood_tracker/mood_input_page.dart';
import '../presentation/pages/mood_tracker/mood_history_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/profile/settings_page.dart';

class AppRouter {
  // Route names
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String homeRoute = '/home';
  static const String conversationRoute = '/conversation';
  static const String startConversationRoute = '/start-conversation';
  static const String conversationHistoryRoute = '/conversation-history';
  static const String journalListRoute = '/journal-list';
  static const String addJournalRoute = '/add-journal';
  static const String journalDetailRoute = '/journal-detail';
  static const String moodInputRoute = '/mood-input';
  static const String moodHistoryRoute = '/mood-history';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String questsRoute = '/quests';
  static const String achievementsRoute = '/achievements';
  static const String rewardsRoute = '/rewards';
  static const String analyticsRoute = '/analytics';
  static const String challengesRoute = '/challenges';
  static const String challengeDetailRoute = '/challenge-detail';
  static const String discussionGroupsRoute = '/discussion-groups';
  static const String discussionGroupRoute = '/discussion-group';
  static const String forumThreadDetailRoute = '/forum-thread';
  static const String forumsRoute = '/forums';
  static const String successStoriesRoute = '/success-stories';
  static const String gamificationRoute = '/gamification';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Community Routes
      case challengesRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CommunityBloc>()..add(LoadChallenges()),
            child: const ChallengesPage(),
          ),
        );

      case challengeDetailRoute:
        final challenge = settings.arguments as CommunityChallenge;
        return MaterialPageRoute(
          builder: (_) => ChallengeDetailPage(challenge: challenge),
        );

      case discussionGroupsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                sl<CommunityBloc>()..add(LoadDiscussionGroups()),
            child: const DiscussionGroupsListPage(),
          ),
        );

      case discussionGroupRoute:
        final String groupId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CommunityBloc>(),
            child: DiscussionGroupPage(groupSlug: groupId),
          ),
        );

      case forumsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CommunityBloc>()..add(LoadForumThreads()),
            child: const ForumsListPage(),
          ),
        );

      case forumThreadDetailRoute:
        final String threadId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CommunityBloc>(),
            child: ForumThreadDetailPage(threadId: threadId),
          ),
        );

      case successStoriesRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CommunityBloc>()..add(LoadSuccessStories()),
            child: const SuccessStoriesPage(),
          ),
        );

      case AppRouter.journalListRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<JournalBloc>()..add(LoadJournalEntries()),
            child: const JournalListPage(),
          ),
        );

      case AppRouter.addJournalRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<JournalBloc>(),
            child: const AddJournalPage(),
          ),
        );
      case analyticsRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final bloc = sl<AnalyticsBloc>();
              bloc.add(LoadMoodAnalytics());
              bloc.add(LoadUserActivity());
              bloc.add(LoadCommunityEngagement());
              return bloc;
            },
            child: const AnalyticsDashboard(),
          ),
        );
      case questsRoute:
        return MaterialPageRoute(builder: (_) => const QuestsPage());
      case gamificationRoute:
        return MaterialPageRoute(builder: (_) => const GamificationDashboard());
      case achievementsRoute:
        return MaterialPageRoute(builder: (_) => const AchievementsPage());
      case rewardsRoute:
        return MaterialPageRoute(builder: (_) => const RewardsPage());
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case conversationRoute:
        final String conversationId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ConversationPage(conversationId: conversationId),
        );
      case startConversationRoute:
        return MaterialPageRoute(builder: (_) => const StartConversationPage());
      case conversationHistoryRoute:
        return MaterialPageRoute(
          builder: (_) => const ConversationHistoryPage(),
        );
      // case journalListRoute:
      //   return MaterialPageRoute(builder: (_) => const JournalListPage());
      // case addJournalRoute:
      //   return MaterialPageRoute(builder: (_) => const AddJournalPage());
      case journalDetailRoute:
        final String journalId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => JournalDetailPage(journalId: journalId),
        );
      case moodInputRoute:
        return MaterialPageRoute(builder: (_) => const MoodInputPage());
      case moodHistoryRoute:
        return MaterialPageRoute(builder: (_) => const MoodHistoryPage());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case '/levels':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<GamificationBloc>()..add(LoadUserPoints()),
            child: const LevelsPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
