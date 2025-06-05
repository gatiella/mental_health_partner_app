// app_streak_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class AppStreakEvent {}

class LoadAppStreak extends AppStreakEvent {}

class RecordAppOpening extends AppStreakEvent {
  final DateTime date;
  RecordAppOpening(this.date);
}

// States
abstract class AppStreakState {}

class AppStreakInitial extends AppStreakState {}

class AppStreakLoading extends AppStreakState {}

class AppStreakLoaded extends AppStreakState {
  final AppOpeningStreak streak;
  AppStreakLoaded(this.streak);
}

class AppStreakError extends AppStreakState {
  final String message;
  AppStreakError(this.message);
}

// Model
class AppOpeningStreak {
  final List<DateTime> openedDays;
  final int currentStreak;
  final DateTime? lastOpenedDate;

  AppOpeningStreak({
    required this.openedDays,
    required this.currentStreak,
    this.lastOpenedDate,
  });

  // Calculate current streak based on opened days
  static AppOpeningStreak calculateStreak(List<DateTime> openedDays) {
    if (openedDays.isEmpty) {
      return AppOpeningStreak(
        openedDays: [],
        currentStreak: 0,
        lastOpenedDate: null,
      );
    }

    // Sort days in descending order
    final sortedDays = List<DateTime>.from(openedDays);
    sortedDays.sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    int streak = 0;
    DateTime currentDate = todayDate;

    // Check if opened today or yesterday (to allow for continuous streak)
    final lastOpened = DateTime(
      sortedDays.first.year,
      sortedDays.first.month,
      sortedDays.first.day,
    );

    final daysSinceLastOpened = todayDate.difference(lastOpened).inDays;

    // If more than 1 day since last opened, streak is broken
    if (daysSinceLastOpened > 1) {
      return AppOpeningStreak(
        openedDays: openedDays,
        currentStreak: 0,
        lastOpenedDate: sortedDays.first,
      );
    }

    // Calculate consecutive days
    for (final openedDay in sortedDays) {
      final openedDate = DateTime(
        openedDay.year,
        openedDay.month,
        openedDay.day,
      );

      if (openedDate.isAtSameMomentAs(currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (openedDate.isBefore(currentDate)) {
        // Gap found, streak breaks
        break;
      }
    }

    return AppOpeningStreak(
      openedDays: openedDays,
      currentStreak: streak,
      lastOpenedDate: sortedDays.first,
    );
  }
}

// Bloc
class AppStreakBloc extends Bloc<AppStreakEvent, AppStreakState> {
  AppStreakBloc() : super(AppStreakInitial()) {
    on<LoadAppStreak>(_onLoadAppStreak);
    on<RecordAppOpening>(_onRecordAppOpening);
  }

  Future<void> _onLoadAppStreak(
    LoadAppStreak event,
    Emitter<AppStreakState> emit,
  ) async {
    emit(AppStreakLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final openedDaysStrings = prefs.getStringList('app_opened_days') ?? [];

      final openedDays = openedDaysStrings
          .map((dateString) => DateTime.parse(dateString))
          .toList();

      final streak = AppOpeningStreak.calculateStreak(openedDays);
      emit(AppStreakLoaded(streak));
    } catch (e) {
      emit(AppStreakError('Failed to load app streak: $e'));
    }
  }

  Future<void> _onRecordAppOpening(
    RecordAppOpening event,
    Emitter<AppStreakState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final openedDaysStrings = prefs.getStringList('app_opened_days') ?? [];

      final openedDays = openedDaysStrings
          .map((dateString) => DateTime.parse(dateString))
          .toList();

      // Create date without time
      final dateOnly =
          DateTime(event.date.year, event.date.month, event.date.day);

      // Check if today is already recorded
      final alreadyRecorded = openedDays.any((day) =>
          day.year == dateOnly.year &&
          day.month == dateOnly.month &&
          day.day == dateOnly.day);

      if (!alreadyRecorded) {
        openedDays.add(dateOnly);

        // Save back to preferences
        final updatedStrings =
            openedDays.map((date) => date.toIso8601String()).toList();

        await prefs.setStringList('app_opened_days', updatedStrings);
      }

      // Recalculate and emit updated streak
      final streak = AppOpeningStreak.calculateStreak(openedDays);
      emit(AppStreakLoaded(streak));
    } catch (e) {
      emit(AppStreakError('Failed to record app opening: $e'));
    }
  }
}
