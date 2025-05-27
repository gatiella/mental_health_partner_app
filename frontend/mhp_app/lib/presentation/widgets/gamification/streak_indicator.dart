// frontend/lib/presentation/widgets/gamification/streak_indicator.dart
import 'package:flutter/material.dart';
import 'package:mental_health_partner/domain/entities/user_streak.dart';

class StreakIndicator extends StatelessWidget {
  final UserStreak streak;
  final bool isCompact;

  const StreakIndicator({
    super.key,
    required this.streak,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        gradient: _getStreakGradient(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStreakColor().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isCompact ? _buildCompactLayout() : _buildFullLayout(),
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getStreakIcon(),
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '${streak.currentStreak}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFullLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _getStreakIcon(),
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak.streakDisplayText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (streak.longestStreak > streak.currentStreak)
                  Text(
                    'Best: ${streak.longestStreak} days',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          streak.motivationalMessage,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
        if (streak.currentStreak > 0 && !streak.completedToday) ...[
          const SizedBox(height: 8),
          _buildStreakWarning(),
        ],
        if (streak.daysUntilNextLevel > 0) ...[
          const SizedBox(height: 8),
          _buildNextLevelProgress(),
        ],
      ],
    );
  }

  Widget _buildStreakWarning() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange[200],
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            'Complete a quest today to keep your streak!',
            style: TextStyle(
              color: Colors.orange[200],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextLevelProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${streak.daysUntilNextLevel} days until ${streak.nextLevelName}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: _getProgressToNextLevel(),
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }

  double _getProgressToNextLevel() {
    // This is a simplified calculation - you might want to make this more sophisticated
    final totalDaysForLevel = _getTotalDaysForNextLevel();
    final completedDays = totalDaysForLevel - streak.daysUntilNextLevel;
    return completedDays / totalDaysForLevel;
  }

  int _getTotalDaysForNextLevel() {
    // Example thresholds - adjust based on your achievement levels
    if (streak.currentStreak < 7) return 7;
    if (streak.currentStreak < 30) return 30;
    if (streak.currentStreak < 100) return 100;
    return 365;
  }

  IconData _getStreakIcon() {
    if (streak.currentStreak == 0) return Icons.play_circle_outline;
    if (streak.currentStreak < 7) return Icons.local_fire_department;
    if (streak.currentStreak < 30) return Icons.whatshot;
    if (streak.currentStreak < 100) return Icons.star;
    return Icons.emoji_events;
  }

  Color _getStreakColor() {
    if (streak.currentStreak == 0) return Colors.grey;
    if (streak.currentStreak < 7) return Colors.orange;
    if (streak.currentStreak < 30) return Colors.red;
    if (streak.currentStreak < 100) return Colors.purple;
    return Colors.amber;
  }

  LinearGradient _getStreakGradient() {
    final color = _getStreakColor();
    return LinearGradient(
      colors: [
        color,
        color.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class StreakCalendar extends StatelessWidget {
  final UserStreak streak;
  final List<DateTime> completedDates;

  const StreakCalendar({
    super.key,
    required this.streak,
    required this.completedDates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildWeekView(),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final date = startOfWeek.add(Duration(days: index));
        final isCompleted = completedDates.any((d) =>
            d.year == date.year && d.month == date.month && d.day == date.day);
        final isToday = date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

        return _buildDayIndicator(date, isCompleted, isToday);
      }),
    );
  }

  Widget _buildDayIndicator(DateTime date, bool isCompleted, bool isToday) {
    return Column(
      children: [
        Text(
          _getDayName(date.weekday),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : isToday
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
            border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isToday ? Colors.blue : Colors.grey[600],
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
