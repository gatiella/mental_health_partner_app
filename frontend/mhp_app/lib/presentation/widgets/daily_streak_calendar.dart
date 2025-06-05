// daily_streak_calendar.dart
import 'package:flutter/material.dart';

class DailyStreakCalendar extends StatelessWidget {
  final List<DateTime> streakDays;
  final int currentStreak;
  final DateTime? lastOpenedDate;

  const DailyStreakCalendar({
    super.key,
    required this.streakDays,
    required this.currentStreak,
    this.lastOpenedDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get the last 14 days for display
    final displayDays = List.generate(14, (index) {
      return today.subtract(Duration(days: 13 - index));
    });

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.3),
              theme.colorScheme.secondaryContainer.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with streak counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Streak',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: _getStreakColor(currentStreak),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$currentStreak day${currentStreak != 1 ? 's' : ''}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: _getStreakColor(currentStreak),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStreakColor(currentStreak).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStreakColor(currentStreak).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getStreakEmoji(currentStreak),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getStreakLevel(currentStreak),
                        style: TextStyle(
                          color: _getStreakColor(currentStreak),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Calendar grid
            SizedBox(
              height: 120,
              child: Column(
                children: [
                  // Week days header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                        .map((day) => SizedBox(
                              width: 32,
                              child: Text(
                                day,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 12),

                  // Calendar days (2 weeks)
                  Expanded(
                    child: Column(
                      children: [
                        // First week
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: displayDays
                                .take(7)
                                .map((day) => _buildDayItem(day, theme, today))
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Second week
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: displayDays
                                .skip(7)
                                .take(7)
                                .map((day) => _buildDayItem(day, theme, today))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('🔥', 'Opened', Colors.orange, theme),
                _buildLegendItem('😴', 'Missed', Colors.grey, theme),
                _buildLegendItem(
                    '📅', 'Today', theme.colorScheme.primary, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayItem(DateTime day, ThemeData theme, DateTime today) {
    final isToday = day.isAtSameMomentAs(today);
    final isOpened = streakDays.any((streakDay) =>
        streakDay.year == day.year &&
        streakDay.month == day.month &&
        streakDay.day == day.day);
    final isFuture = day.isAfter(today);

    String emoji;
    Color backgroundColor;
    Color borderColor;

    if (isFuture) {
      emoji = '⭕';
      backgroundColor = Colors.transparent;
      borderColor = Colors.transparent;
    } else if (isToday) {
      emoji = isOpened ? '🔥' : '📅';
      backgroundColor = theme.colorScheme.primary.withOpacity(0.2);
      borderColor = theme.colorScheme.primary;
    } else if (isOpened) {
      emoji = '🔥';
      backgroundColor = Colors.orange.withOpacity(0.2);
      borderColor = Colors.orange;
    } else {
      emoji = '😴';
      backgroundColor = Colors.grey.withOpacity(0.2);
      borderColor = Colors.grey;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: isToday ? 2 : 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: isFuture ? 8 : 12),
            ),
            if (!isFuture)
              Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: isToday
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
      String emoji, String label, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStreakColor(int streak) {
    if (streak == 0) return Colors.grey;
    if (streak < 3) return Colors.orange;
    if (streak < 7) return Colors.red;
    if (streak < 14) return Colors.purple;
    if (streak < 30) return Colors.blue;
    return Colors.amber;
  }

  String _getStreakEmoji(int streak) {
    if (streak == 0) return '😴';
    if (streak < 3) return '🔥';
    if (streak < 7) return '💪';
    if (streak < 14) return '⭐';
    if (streak < 30) return '💎';
    return '👑';
  }

  String _getStreakLevel(int streak) {
    if (streak == 0) return 'Start';
    if (streak < 3) return 'Beginner';
    if (streak < 7) return 'Getting Started';
    if (streak < 14) return 'Committed';
    if (streak < 30) return 'Dedicated';
    return 'Champion';
  }
}
