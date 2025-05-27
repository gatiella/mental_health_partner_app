import 'package:equatable/equatable.dart';

class Mood extends Equatable {
  final String id;
  final int rating; // Keep as rating for UI compatibility
  final String? notes; // Keep as notes for UI compatibility
  final DateTime createdAt;
  final DateTime timestamp;

  const Mood({
    required this.id,
    required this.rating,
    this.notes,
    required this.createdAt,
    required this.timestamp,
  });

  // Method to get mood name based on rating (matching Django choices)
  String get moodName {
    switch (rating) {
      case 1:
        return 'Very Bad';
      case 2:
        return 'Bad';
      case 3:
        return 'Poor';
      case 4:
        return 'Below Average';
      case 5:
        return 'Average';
      case 6:
        return 'Above Average';
      case 7:
        return 'Good';
      case 8:
        return 'Very Good';
      case 9:
        return 'Great';
      case 10:
        return 'Excellent';
      default:
        return 'Unknown';
    }
  }

  @override
  List<Object> get props => [id, rating, createdAt, timestamp];
}
