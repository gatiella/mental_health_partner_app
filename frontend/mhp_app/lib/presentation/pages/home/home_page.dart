import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_partner/presentation/blocs/app_streak/app_streak_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_state.dart';
import 'package:mental_health_partner/presentation/blocs/gamification/gamification_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_event.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_state.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_event.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_state.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';
import 'package:mental_health_partner/presentation/widgets/daily_streak_calendar.dart';
import 'package:mental_health_partner/presentation/widgets/mood/mood_chart.dart';
import 'package:mental_health_partner/presentation/widgets/gamification/streak_indicator.dart';
import 'package:mental_health_partner/domain/entities/user_streak.dart';
import 'side_menu.dart';
import '../../../config/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  void _loadData() {
    context.read<MoodBloc>().add(LoadMoodHistory());
    context.read<JournalBloc>().add(LoadJournalEntries());
    context.read<GamificationBloc>().add(LoadUserStreak());
    context.read<AppStreakBloc>().add(RecordAppOpening(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return _HomePageContent(onRefresh: _loadData);
  }
}

// Separate stateless widget to handle the content
class _HomePageContent extends StatelessWidget {
  final VoidCallback onRefresh;

  const _HomePageContent({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quotes = _QuotesRepository.getQuotes();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      drawer: const SideMenu(),
      body: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child: CustomScrollView(
          slivers: [
            // Modern App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: isDark
                  ? AppColors.primaryDarkColor
                  : AppColors.primaryLightColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.primaryDarkColor,
                              AppColors.primaryLightColor
                            ]
                          : [
                              AppColors.primaryDarkColor,
                              AppColors.primaryLightColor
                            ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          String greeting = _getTimeBasedGreeting();
                          if (state is Authenticated) {
                            greeting = '$greeting, ${state.user.username}!';
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                greeting,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1A1A1A),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('EEEE, MMMM d')
                                    .format(DateTime.now()),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                // Enhanced streak button
                BlocBuilder<GamificationBloc, GamificationState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: InkWell(
                        onTap: () => _showStreakDialog(context, state),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getStreakColor(state),
                                _getStreakColor(state).withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _getStreakColor(state).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStreakIcon(state),
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getStreakText(state),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: BlocBuilder<MoodBloc, MoodState>(
                builder: (context, state) {
                  if (state is MoodInitial || state is MoodLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is MoodError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          "Error loading chart: ${state.message}",
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    );
                  }
                  if (state is MoodHistoryLoaded) {
                    final analytics = state.analytics;
                    final ratings = analytics['weekly_ratings'] ?? [];
                    final hasData = ratings.isNotEmpty;
                    final avgMood = _calculateAverageMood(ratings);

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Enhanced Quote Card
                          _buildQuoteCard(theme, quotes, isDark),
                          const SizedBox(height: 24),

                          // Daily Streak Calendar with enhanced design
                          BlocBuilder<AppStreakBloc, AppStreakState>(
                            builder: (context, streakState) {
                              if (streakState is AppStreakLoaded) {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF1A1A1A)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                isDark ? 0.3 : 0.08),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: DailyStreakCalendar(
                                          streakDays:
                                              streakState.streak.openedDays,
                                          currentStreak:
                                              streakState.streak.currentStreak,
                                          lastOpenedDate:
                                              streakState.streak.lastOpenedDate,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              } else if (streakState is AppStreakLoading) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF1A1A1A)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                isDark ? 0.3 : 0.08),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF1A1A1A)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                isDark ? 0.3 : 0.08),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: const DailyStreakCalendar(
                                          streakDays: [],
                                          currentStreak: 0,
                                          lastOpenedDate: null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              }
                            },
                          ),

                          // Enhanced Mood Input Prompt
                          _buildMoodInputPrompt(context, theme, isDark),
                          const SizedBox(height: 24),

                          // Enhanced Mood Chart
                          Container(
                            height: 280,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(isDark ? 0.3 : 0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: hasData
                                  ? MoodChart(
                                      analyticsData: analytics,
                                      moodHistory: state.history,
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.analytics_outlined,
                                            size: 48,
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.6),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            "No chart data available",
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Enhanced Quick Stats
                          _buildQuickStats(context, theme, avgMood, isDark),
                          const SizedBox(height: 32),

                          // Enhanced Recent Journal Entries
                          _buildRecentJournalEntries(context, theme, isDark),
                          const SizedBox(height: 100), // Space for bottom nav
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, theme, isDark),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRouter.questsRoute);
          },
          tooltip: 'Active Quests',
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.flag, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  void _showStreakDialog(BuildContext context, GamificationState state) {
    UserStreak streak;

    if (state is StreakLoaded) {
      streak = state.streak;
    } else {
      // Default streak for error states
      streak = const UserStreak(
        currentStreak: 0,
        longestStreak: 0,
        completedToday: false,
        daysUntilNextLevel: 1,
        nextLevelName: 'Beginner',
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surfaceContainerHighest,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Streak',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Streak Indicator
                if (state is StreakLoaded)
                  StreakIndicator(
                    streak: streak,
                    isCompact: false,
                  )
                else if (state is StreakLoading)
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: const CircularProgressIndicator(),
                  )
                else if (state is StreakError)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.error, color: Colors.red[400], size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'Unable to load streak data',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ],
                    ),
                  )
                else
                  StreakIndicator(
                    streak: streak,
                    isCompact: false,
                  ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(AppRouter.questsRoute);
                        },
                        icon: const Icon(Icons.flag),
                        label: const Text('Start Quest'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigate to achievements or streak history page
                        },
                        icon: const Icon(Icons.emoji_events),
                        label: const Text('View All'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStreakText(GamificationState state) {
    if (state is StreakLoaded) {
      return '${state.streak.currentStreak}';
    } else if (state is StreakLoading) {
      return '...';
    } else {
      return '0';
    }
  }

  IconData _getStreakIcon(GamificationState state) {
    if (state is StreakLoaded) {
      final streak = state.streak.currentStreak;
      if (streak == 0) return Icons.play_circle_outline;
      if (streak < 7) return Icons.local_fire_department;
      if (streak < 30) return Icons.whatshot;
      if (streak < 100) return Icons.star;
      return Icons.emoji_events;
    } else if (state is StreakLoading) {
      return Icons.hourglass_empty;
    } else {
      return Icons.error_outline;
    }
  }

  Color _getStreakColor(GamificationState state) {
    if (state is StreakLoaded) {
      final streak = state.streak.currentStreak;
      if (streak == 0) return const Color(0xFF94A3B8);
      if (streak < 7) return const Color(0xFFFF6B35);
      if (streak < 30) return const Color(0xFFE53E3E);
      if (streak < 100) return const Color(0xFF8B5CF6);
      return const Color(0xFFF59E0B);
    } else if (state is StreakLoading) {
      return const Color(0xFF3B82F6);
    } else {
      return const Color(0xFFEF4444);
    }
  }

  Widget _buildMoodInputPrompt(
      BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF334155)]
              : [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF1E293B) : const Color(0xFF3B82F6))
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your mood to better understand yourself',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodButton(context, '😔', 'Sad', theme),
              _buildMoodButton(context, '😐', 'Neutral', theme),
              _buildMoodButton(context, '🙂', 'Good', theme),
              _buildMoodButton(context, '😄', 'Great', theme),
              _buildMoodButton(context, '😁', 'Excellent', theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(
      BuildContext context, String emoji, String label, ThemeData theme) {
    return InkWell(
      onTap: () async {
        final result =
            await Navigator.of(context).pushNamed(AppRouter.moodInputRoute);
        if (result == true) {
          // Refresh data
          onRefresh();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentJournalEntries(
      BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Journal Entries',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouter.journalListRoute);
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            if (state is JournalLoading) {
              return Container(
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is JournalError) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Error loading journal entries: ${state.message}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is JournalEntriesLoaded) {
              final entries = state.entries;

              if (entries.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.book_outlined,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No journal entries yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first entry to track your thoughts and feelings',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.of(context)
                              .pushNamed(AppRouter.addJournalRoute);
                          if (result == true) {
                            // Refresh data
                            onRefresh();
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Entry'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show up to 3 most recent entries
              return Column(
                children: entries
                    .take(3)
                    .map((entry) =>
                        _buildJournalEntryItem(entry, theme, context, isDark))
                    .toList(),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildJournalEntryItem(
      dynamic entry, ThemeData theme, BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(
          entry.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              entry.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatDate(entry.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.journalDetailRoute,
            arguments: entry.id,
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  double _calculateAverageMood(List<dynamic> ratings) {
    if (ratings.isEmpty) return 0;

    final total = ratings
        .map((entry) => (entry['average'] ?? 0).toDouble())
        .reduce((a, b) => a + b);

    return total / ratings.length;
  }

  Widget _buildQuoteCard(ThemeData theme, List<String> quotes, bool isDark) {
    final randomQuote = quotes[DateTime.now().second % quotes.length];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF475569)]
              : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF1E293B) : const Color(0xFF6366F1))
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.format_quote,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                randomQuote,
                key: ValueKey(randomQuote),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  height: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
      BuildContext context, ThemeData theme, double avgMood, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weekly Summary",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            int entryCount = 0;
            if (state is JournalEntriesLoaded) {
              entryCount = state.entries.length;
            }

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    Icons.mood,
                    avgMood.toStringAsFixed(1),
                    'Avg Mood',
                    theme,
                    const Color(0xFF10B981),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  _StatItem(
                    Icons.edit_note,
                    entryCount.toString(),
                    'Entries',
                    theme,
                    const Color(0xFF3B82F6),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  _StatItem(
                    Icons.flag,
                    '3',
                    'Quests',
                    theme,
                    const Color(0xFF8B5CF6),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(
      BuildContext context, ThemeData theme, bool isDark) {
    const List<_NavItem> navItems = [
      _NavItem(
          Icons.chat_bubble_outline, 'Chat', AppRouter.startConversationRoute),
      _NavItem(Icons.mood_outlined, 'Mood', AppRouter.moodInputRoute),
      _NavItem(Icons.book_outlined, 'Journal', AppRouter.journalListRoute),
      _NavItem(Icons.group_rounded, 'Community', AppRouter.challengesRoute),
      _NavItem(Icons.person_outline, 'Profile', AppRouter.profileRoute),
    ];

    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(item.route);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: index == 0
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: index == 0
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        color: index == 0
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            index == 0 ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌅';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }
}

class _QuotesRepository {
  static List<String> getQuotes() => [
        "You are capable of amazing things.",
        "Progress, not perfection.",
        "Your mental health is a priority.",
        "It's okay to not be okay.",
        "Small steps still move you forward.",
        "You're stronger than you think.",
        "Healing is not linear.",
        "Your feelings are valid.",
        "Tomorrow is a new opportunity.",
        "Self-care is not selfish.",
      ];
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final ThemeData theme;
  final Color color;

  const _StatItem(this.icon, this.value, this.label, this.theme, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem(this.icon, this.label, this.route);
}
