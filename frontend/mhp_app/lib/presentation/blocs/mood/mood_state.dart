import 'package:equatable/equatable.dart';
import '../../../../domain/entities/mood.dart';

abstract class MoodState extends Equatable {
  const MoodState();
}

class MoodInitial extends MoodState {
  @override
  List<Object> get props => [];
}

class MoodLoading extends MoodState {
  @override
  List<Object> get props => [];
}

class MoodRecorded extends MoodState {
  @override
  List<Object> get props => [];
}

class MoodHistoryLoaded extends MoodState {
  final List<Mood> history;
  final Map<String, dynamic> analytics;

  const MoodHistoryLoaded(this.history,
      {this.analytics = const {'weekly_ratings': []}});

  @override
  List<Object> get props => [history];
}

class MoodError extends MoodState {
  final String message;

  const MoodError(this.message);

  @override
  List<Object> get props => [message];
}
