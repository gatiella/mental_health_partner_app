import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_event.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_event.dart';
import 'package:mental_health_partner/presentation/blocs/gamification/gamification_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/profile/profile_bloc.dart';
import 'package:mental_health_partner/presentation/themes/theme_cubit.dart';
import 'config/routes.dart';
import 'di/injection_container.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/themes/app_theme.dart';

class MentalHealthApp extends StatefulWidget {
  const MentalHealthApp({super.key});

  // ignore: library_private_types_in_public_api
  static _MentalHealthAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MentalHealthAppState>()!;

  @override
  State<MentalHealthApp> createState() => _MentalHealthAppState();
}

class _MentalHealthAppState extends State<MentalHealthApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
        BlocProvider<AuthBloc>(
            create: (_) => sl<AuthBloc>()..add(CheckAuthStatus())),
        BlocProvider<ConversationBloc>(
            create: (_) => sl<ConversationBloc>()..add(LoadConversations())),
        BlocProvider<GamificationBloc>(
            create: (_) => sl<GamificationBloc>()..add(LoadUserPoints())),
        BlocProvider<JournalBloc>(create: (_) => sl<JournalBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<MoodBloc>(create: (_) => sl<MoodBloc>()),
        BlocProvider<CommunityBloc>(create: (_) => sl<CommunityBloc>()),
        BlocProvider<GamificationBloc>(
            create: (context) => sl<GamificationBloc>()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Mental Health Partner',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.splashRoute,
          );
        },
      ),
    );
  }
}
