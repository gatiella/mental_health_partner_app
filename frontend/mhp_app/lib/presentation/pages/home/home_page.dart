import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_state.dart';
import 'package:mental_health_partner/presentation/blocs/gamification/gamification_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_event.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_state.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_event.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_state.dart';
import 'package:mental_health_partner/presentation/widgets/mood/mood_chart.dart';
import 'package:mental_health_partner/presentation/widgets/gamification/streak_indicator.dart';
import 'package:mental_health_partner/domain/entities/user_streak.dart';
import 'side_menu.dart';
import '../../../config/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load mood history
    context.read<MoodBloc>().add(LoadMoodHistory());
    // Load journal entries
    context.read<JournalBloc>().add(LoadJournalEntries());
    context.read<GamificationBloc>().add(LoadUserStreak());
    return _HomePageContent();
  }
}

// Separate stateless widget to handle the content
class _HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quotes = _QuotesRepository.getQuotes();

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        elevation: 0,
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            String greeting = _getTimeBasedGreeting();
            if (state is Authenticated) {
              greeting = '$greeting, ${state.user.username}!';
            }
            return Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    greeting,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<MoodBloc, MoodState>(
        builder: (context, state) {
          if (state is MoodInitial || state is MoodLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoodError) {
            return Center(child: Text("Error loading chart: ${state.message}"));
          }

          if (state is MoodHistoryLoaded) {
            final analytics = state.analytics;
            final ratings = analytics['weekly_ratings'] ?? [];
            final hasData = ratings.isNotEmpty;
            final avgMood = _calculateAverageMood(ratings);

            return RefreshIndicator(
              onRefresh: () async {
                // Reload mood, journal, and streak data
                context.read<MoodBloc>().add(LoadMoodHistory());
                context.read<JournalBloc>().add(LoadJournalEntries());
                context.read<GamificationBloc>().add(LoadUserStreak());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildQuoteCard(theme, quotes),
                  const SizedBox(height: 20),
                  // Streak indicator
                  BlocBuilder<GamificationBloc, GamificationState>(
                    builder: (context, state) {
                      if (state is StreakLoaded) {
                        return StreakIndicator(
                          streak: state.streak,
                          isCompact: false,
                        );
                      } else if (state is StreakLoading) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is StreakError) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.red[300]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Unable to load streak data',
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // Fallback with default streak
                      return const StreakIndicator(
                        streak: UserStreak(
                          currentStreak: 0,
                          longestStreak: 0,
                          completedToday: false,
                          daysUntilNextLevel: 1,
                          nextLevelName: 'Beginner',
                        ),
                        isCompact: false,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMoodInputPrompt(context, theme),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 250,
                      padding: const EdgeInsets.only(top: 8),
                      child: hasData
                          ? MoodChart(analyticsData: analytics)
                          : const Center(
                              child: Text("No chart data available")),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildQuickStats(context, theme, avgMood),
                  const SizedBox(height: 24),
                  _buildRecentJournalEntries(context, theme),
                  // const SizedBox(height: 20),
                  // _buildCommunityQuickAccess(context, theme),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(context, theme, isDark),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRouter.questsRoute);
        },
        tooltip: 'Active Quests',
        child: const Icon(Icons.flag, size: 28),
      ),
    );
  }

  // Widget _buildCommunityQuickAccess(BuildContext context, ThemeData theme) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Community Hub',
  //         style: theme.textTheme.titleMedium,
  //       ),
  //       const SizedBox(height: 12),
  //       GridView.count(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         crossAxisCount: 2,
  //         childAspectRatio: 1.5,
  //         mainAxisSpacing: 12,
  //         crossAxisSpacing: 12,
  //         children: [
  //           _buildCommunityCard(
  //             context,
  //             icon: Icons.group_work_rounded,
  //             title: 'Challenges',
  //             route: AppRouter.challengesRoute,
  //             color: theme.colorScheme.primaryContainer,
  //           ),
  //           _buildCommunityCard(
  //             context,
  //             icon: Icons.forum_rounded,
  //             title: 'Discussions',
  //             route: AppRouter.discussionGroupsRoute,
  //             color: theme.colorScheme.secondaryContainer,
  //           ),
  //           _buildCommunityCard(
  //             context,
  //             icon: Icons.chat_bubble_rounded,
  //             title: 'Forums',
  //             route: AppRouter.forumsRoute,
  //             color: theme.colorScheme.tertiaryContainer,
  //           ),
  //           _buildCommunityCard(
  //             context,
  //             icon: Icons.celebration_rounded,
  //             title: 'Success Stories',
  //             route: AppRouter.successStoriesRoute,
  //             color: theme.colorScheme.errorContainer,
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildCommunityCard(
  //   BuildContext context, {
  //   required IconData icon,
  //   required String title,
  //   required String route,
  //   required Color color,
  // }) {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(12),
  //       onTap: () => Navigator.pushNamed(context, route),
  //       child: Container(
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: color,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(icon,
  //                 size: 32,
  //                 color: Theme.of(context).colorScheme.onPrimaryContainer),
  //             const SizedBox(height: 8),
  //             Text(
  //               title,
  //               style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //                     color: Theme.of(context).colorScheme.onPrimaryContainer,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMoodInputPrompt(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodButton(context, '😔', 'sad', theme),
              _buildMoodButton(context, '😐', 'neutral', theme),
              _buildMoodButton(context, '🙂', 'good', theme),
              _buildMoodButton(context, '😄', 'great', theme),
              _buildMoodButton(context, '😁', 'excellent', theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(
      BuildContext context, String emoji, String label, ThemeData theme) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRouter.moodInputRoute);
      },
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJournalEntries(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Journal Entries',
              style: theme.textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouter.journalListRoute);
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            if (state is JournalLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is JournalError) {
              return Center(
                child: Text("Error loading journal entries: ${state.message}"),
              );
            }

            if (state is JournalEntriesLoaded) {
              final entries = state.entries;

              if (entries.isEmpty) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 48,
                          color: theme.colorScheme.primary.withOpacity(0.7),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No journal entries yet',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create your first entry to track your thoughts and feelings',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRouter.addJournalRoute);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Entry'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show up to 3 most recent entries
              return Column(
                children: entries
                    .take(3)
                    .map((entry) =>
                        _buildJournalEntryItem(entry, theme, context))
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
      dynamic entry, ThemeData theme, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          entry.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              entry.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(entry.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildQuoteCard(ThemeData theme, List<String> quotes) {
    final randomQuote = quotes[DateTime.now().second % quotes.length];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondaryContainer,
            theme.colorScheme.tertiaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.format_quote,
              size: 36, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                randomQuote,
                key: ValueKey(randomQuote),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
      BuildContext context, ThemeData theme, double avgMood) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Weekly Summary", style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            int entryCount = 0;
            if (state is JournalEntriesLoaded) {
              entryCount = state.entries.length;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                    Icons.mood, avgMood.toStringAsFixed(1), 'Avg Mood', theme),
                _StatItem(
                    Icons.edit_note, entryCount.toString(), 'Entries', theme),
                _StatItem(Icons.flag, '3', 'Quests', theme),
              ],
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
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          return IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(item.route);
            },
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: theme.colorScheme.primary, size: 26),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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

  const _StatItem(this.icon, this.value, this.label, this.theme);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(value, style: theme.textTheme.titleLarge),
        Text(label, style: theme.textTheme.bodySmall),
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
