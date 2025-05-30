import 'package:flutter/material.dart';
import 'package:mental_health_partner/domain/entities/mood.dart';

// Option 1: Mood Summary Cards
class MoodSummaryCards extends StatelessWidget {
  final Map<String, dynamic> analyticsData;
  final List<dynamic>? moodHistory;

  const MoodSummaryCards({
    super.key,
    required this.analyticsData,
    this.moodHistory,
  });

  @override
  Widget build(BuildContext context) {
    final stats = _calculateMoodStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatCard(
          'Average Mood',
          stats['average'].toStringAsFixed(1),
          _getMoodIcon(stats['average'].round()),
          _getMoodColor(stats['average'].round()),
        ),
        const SizedBox(height: 12),
        _buildMoodTrendIndicator(stats['trend']),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrendIndicator(String trend) {
    Color trendColor;
    IconData trendIcon;
    String trendText;

    switch (trend) {
      case 'improving':
        trendColor = Colors.green;
        trendIcon = Icons.trending_up;
        trendText = 'Your mood is improving!';
        break;
      case 'declining':
        trendColor = Colors.orange;
        trendIcon = Icons.trending_down;
        trendText = 'Consider some self-care';
        break;
      default:
        trendColor = Colors.blue;
        trendIcon = Icons.trending_flat;
        trendText = 'Your mood is stable';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(trendIcon, color: trendColor, size: 20),
          const SizedBox(width: 8),
          Text(
            trendText,
            style: TextStyle(
              color: trendColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateMoodStats() {
    if (moodHistory == null || moodHistory!.isEmpty) {
      return {
        'average': 5.0,
        'trend': 'stable',
      };
    }

    double totalRating = 0;
    int count = 0;

    for (var mood in moodHistory!) {
      int rating;

      if (mood is Map<String, dynamic>) {
        rating = mood['score'] ?? 5;
      } else {
        rating = (mood as Mood).rating;
      }

      totalRating += rating;
      count++;
    }

    final average = count > 0 ? totalRating / count : 5.0;

    // Simple trend calculation (comparing first half vs second half)
    String trend = 'stable';
    if (count >= 4) {
      final firstHalf = moodHistory!.take(count ~/ 2);
      final secondHalf = moodHistory!.skip(count ~/ 2);

      double firstAvg = 0, secondAvg = 0;
      for (var mood in firstHalf) {
        firstAvg +=
            (mood is Map) ? (mood['score'] ?? 5) : (mood as Mood).rating;
      }
      for (var mood in secondHalf) {
        secondAvg +=
            (mood is Map) ? (mood['score'] ?? 5) : (mood as Mood).rating;
      }

      firstAvg /= firstHalf.length;
      secondAvg /= secondHalf.length;

      if (secondAvg > firstAvg + 0.5) {
        trend = 'improving';
      } else if (secondAvg < firstAvg - 0.5) trend = 'declining';
    }

    return {
      'average': average,
      'trend': trend,
    };
  }

  IconData _getMoodIcon(int rating) {
    if (rating <= 3) return Icons.sentiment_very_dissatisfied;
    if (rating <= 5) return Icons.sentiment_dissatisfied;
    if (rating <= 7) return Icons.sentiment_neutral;
    if (rating <= 8) return Icons.sentiment_satisfied;
    return Icons.sentiment_very_satisfied;
  }

  Color _getMoodColor(int rating) {
    if (rating <= 3) return Colors.red;
    if (rating <= 5) return Colors.orange;
    if (rating <= 7) return Colors.yellow[700]!;
    if (rating <= 8) return Colors.lightGreen;
    return Colors.green;
  }
}

// Option 2: Recent Mood Timeline
class RecentMoodTimeline extends StatelessWidget {
  final Map<String, dynamic> analyticsData;
  final List<dynamic>? moodHistory;

  const RecentMoodTimeline({
    super.key,
    required this.analyticsData,
    this.moodHistory,
  });

  @override
  Widget build(BuildContext context) {
    final recentMoods = _getRecentMoods();

    if (recentMoods.isEmpty) {
      return const Center(
        child: Text(
          'No recent mood entries',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last 7 days',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentMoods.length,
            itemBuilder: (context, index) {
              final mood = recentMoods[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildMoodDot(mood),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoodDot(Map<String, dynamic> mood) {
    final rating = mood['rating'] as int;
    final date = mood['date'] as DateTime;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getMoodColor(rating),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _getMoodColor(rating).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              rating.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${date.day}/${date.month}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getRecentMoods() {
    if (moodHistory == null || moodHistory!.isEmpty) return [];

    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final recent = <Map<String, dynamic>>[];

    for (var mood in moodHistory!) {
      int rating;
      DateTime date;

      if (mood is Map<String, dynamic>) {
        rating = mood['score'] ?? 5;
        date = DateTime.tryParse(mood['created_at'] ?? '') ?? DateTime.now();
      } else {
        rating = (mood as Mood).rating;
        date = mood.createdAt;
      }

      if (date.isAfter(sevenDaysAgo)) {
        recent.add({'rating': rating, 'date': date});
      }
    }

    recent.sort(
        (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    return recent.take(7).toList();
  }

  Color _getMoodColor(int rating) {
    if (rating <= 3) return Colors.red;
    if (rating <= 5) return Colors.orange;
    if (rating <= 7) return Colors.yellow[700]!;
    if (rating <= 8) return Colors.lightGreen;
    return Colors.green;
  }
}

// Option 3: Mood Progress Bar
class MoodProgressIndicator extends StatelessWidget {
  final Map<String, dynamic> analyticsData;
  final List<dynamic>? moodHistory;

  const MoodProgressIndicator({
    super.key,
    required this.analyticsData,
    this.moodHistory,
  });

  @override
  Widget build(BuildContext context) {
    final stats = _calculateWeeklyProgress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '${stats['percentage'].toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getProgressColor(stats['percentage']),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: stats['percentage'] / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(stats['percentage']),
          ),
          minHeight: 8,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${stats['entries']} entries this week',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Goal: Daily check-ins',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, dynamic> _calculateWeeklyProgress() {
    if (moodHistory == null || moodHistory!.isEmpty) {
      return {'percentage': 0.0, 'entries': 0};
    }

    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    int thisWeekEntries = 0;

    for (var mood in moodHistory!) {
      DateTime date;
      if (mood is Map<String, dynamic>) {
        date = DateTime.tryParse(mood['created_at'] ?? '') ?? DateTime.now();
      } else {
        date = (mood as Mood).createdAt;
      }

      if (date.isAfter(oneWeekAgo)) {
        thisWeekEntries++;
      }
    }

    final percentage = (thisWeekEntries / 7 * 100).clamp(0.0, 100.0);
    return {'percentage': percentage, 'entries': thisWeekEntries};
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.lightGreen;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }
}
