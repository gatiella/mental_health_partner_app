// frontend/lib/domain/entities/user_streak.dart
import 'package:equatable/equatable.dart';

class UserStreak extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletionDate;
  final bool completedToday;
  final int daysUntilNextLevel;
  final String nextLevelName;

  const UserStreak({
    required this.currentStreak,
    required this.longestStreak,
    this.lastCompletionDate,
    required this.completedToday,
    required this.daysUntilNextLevel,
    required this.nextLevelName,
  });

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        lastCompletionDate,
        completedToday,
        daysUntilNextLevel,
        nextLevelName,
      ];

  UserStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCompletionDate,
    bool? completedToday,
    int? daysUntilNextLevel,
    String? nextLevelName,
  }) {
    return UserStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
      completedToday: completedToday ?? this.completedToday,
      daysUntilNextLevel: daysUntilNextLevel ?? this.daysUntilNextLevel,
      nextLevelName: nextLevelName ?? this.nextLevelName,
    );
  }

  String get streakDisplayText {
    if (currentStreak == 0) return "Start your streak!";
    if (currentStreak == 1) return "1 day streak";
    return "$currentStreak day streak";
  }

  String get motivationalMessage {
    if (completedToday) {
      return "Great job! Keep it going tomorrow!";
    } else if (currentStreak == 0) {
      return "Complete a quest today to start your streak!";
    } else {
      return "Don't break your $currentStreak day streak!";
    }
  }
}
