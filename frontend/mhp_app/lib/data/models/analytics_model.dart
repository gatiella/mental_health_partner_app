import 'package:equatable/equatable.dart';

class MoodAnalytics {
  final Map<String, int> moodDistribution;
  final double weeklyAverage;
  final List<DailyMood> dailyTrends;

  MoodAnalytics({
    required this.moodDistribution,
    required this.weeklyAverage,
    required this.dailyTrends,
  });

  factory MoodAnalytics.fromJson(Map<String, dynamic> json) => MoodAnalytics(
        moodDistribution: Map<String, int>.from(json['mood_distribution']),
        weeklyAverage: json['weekly_average'].toDouble(),
        dailyTrends: List<DailyMood>.from(
            json['daily_trends'].map((x) => DailyMood.fromJson(x))),
      );
}

class DailyMood {
  final DateTime date;
  final double averageRating;

  DailyMood({required this.date, required this.averageRating});

  factory DailyMood.fromJson(Map<String, dynamic> json) => DailyMood(
        date: DateTime.parse(json['date']),
        averageRating: json['average_rating'].toDouble(),
      );
}

class UserActivity extends Equatable {
  final int conversationsCount;
  final int messagesCount;
  final int journalsCount;
  final int moodsCount;
  final double conversationMinutes;

  const UserActivity({
    required this.conversationsCount,
    required this.messagesCount,
    required this.journalsCount,
    required this.moodsCount,
    required this.conversationMinutes,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      conversationsCount: json['conversations_count'] ?? 0,
      messagesCount: json['messages_count'] ?? 0,
      journalsCount: json['journals_count'] ?? 0,
      moodsCount: json['moods_count'] ?? 0,
      conversationMinutes: (json['conversation_minutes'] ?? 0.0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        conversationsCount,
        messagesCount,
        journalsCount,
        moodsCount,
        conversationMinutes,
      ];
}
