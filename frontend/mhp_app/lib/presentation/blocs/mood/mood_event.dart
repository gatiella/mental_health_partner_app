import 'package:equatable/equatable.dart';

abstract class MoodEvent extends Equatable {
  const MoodEvent();
}

class RecordMood extends MoodEvent {
  final int rating;
  final String notes;

  const RecordMood({required this.rating, required this.notes});

  @override
  List<Object> get props => [rating, notes];
}

class LoadMoodHistory extends MoodEvent {
  @override
  List<Object> get props => [];
}
