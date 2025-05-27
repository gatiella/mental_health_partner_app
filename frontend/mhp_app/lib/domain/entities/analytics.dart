// lib/domain/entities/analytics.dart
import 'package:equatable/equatable.dart';

class UserActivity extends Equatable {
  final int journalEntriesCount;
  final int conversationCount;
  final int moodEntriesCount;
  final DateTime periodStart;
  final DateTime periodEnd;

  const UserActivity({
    required this.journalEntriesCount,
    required this.conversationCount,
    required this.moodEntriesCount,
    required this.periodStart,
    required this.periodEnd,
  });

  @override
  List<Object> get props => [
        journalEntriesCount,
        conversationCount,
        moodEntriesCount,
        periodStart,
        periodEnd,
      ];
}
