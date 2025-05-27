import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/domain/entities/mood.dart';
import '../../../../domain/usecases/mood/get_mood_history_usecase.dart';
import '../../../../domain/usecases/mood/record_mood_usecase.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final RecordMoodUseCase recordMood;
  final GetMoodHistoryUseCase getHistory;

  MoodBloc({required this.recordMood, required this.getHistory})
      : super(MoodInitial()) {
    on<RecordMood>(_onRecordMood);
    on<LoadMoodHistory>(_onLoadHistory);
  }

  Future<void> _onRecordMood(
    RecordMood event,
    Emitter<MoodState> emit,
  ) async {
    emit(MoodLoading());

    try {
      final result = await recordMood(event.rating, event.notes);
      result.fold(
        (failure) {
          print('Record mood failure: ${failure.message}');
          emit(MoodError(failure.message));
        },
        (_) {
          emit(MoodRecorded());
          // After successfully recording, reload the history
          add(LoadMoodHistory());
        },
      );
    } catch (e) {
      print('Unexpected error in _onRecordMood: $e');
      emit(MoodError('Unexpected error: $e'));
    }
  }

  Future<void> _onLoadHistory(
    LoadMoodHistory event,
    Emitter<MoodState> emit,
  ) async {
    // Don't emit loading state if we're just refreshing after a record
    if (state is! MoodRecorded) {
      emit(MoodLoading());
    }

    try {
      final result = await getHistory();
      result.fold(
        (failure) {
          print('Load history failure: ${failure.message}');
          emit(MoodError(failure.message));
        },
        (history) {
          print('Loaded mood history: ${history.length} items');

          // Make sure we have data
          if (history.isEmpty) {
            emit(MoodHistoryLoaded(history, analytics: const {'weekly_ratings': []}));
            return;
          }

          try {
            // Generate analytics data
            final analytics = _generateAnalyticsFromHistory(history);
            emit(MoodHistoryLoaded(history, analytics: analytics));
          } catch (e) {
            print('Error generating analytics: $e');
            // Still show the history even if analytics fails
            emit(MoodHistoryLoaded(history,
                analytics: const {'error': 'Failed to generate analytics'}));
          }
        },
      );
    } catch (e) {
      print('Unexpected error in _onLoadHistory: $e');
      emit(MoodError('Unexpected error: $e'));
    }
  }

  Map<String, dynamic> _generateAnalyticsFromHistory(List<Mood> history) {
    // Safeguard for empty history
    if (history.isEmpty) {
      return {'weekly_ratings': []};
    }

    // Logic to generate weekly ratings from history
    final weeklyRatings = List.generate(7, (index) {
      final dayMoods =
          history.where((mood) => mood.timestamp.weekday == index + 1).toList();

      final average = dayMoods.isEmpty
          ? 0.0
          : dayMoods.map((m) => m.rating).reduce((a, b) => a + b) /
              dayMoods.length;

      return {
        'day': index,
        'average': average,
      };
    });

    return {
      'weekly_ratings': weeklyRatings,
    };
  }
}
