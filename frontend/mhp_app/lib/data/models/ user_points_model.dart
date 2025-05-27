import 'package:equatable/equatable.dart';
import 'package:mental_health_partner/domain/entities/user_points.dart';

class UserPointsModel extends Equatable {
  final int totalPoints;
  final int currentPoints;
  final DateTime lastUpdated;

  const UserPointsModel({
    required this.totalPoints,
    required this.currentPoints,
    required this.lastUpdated,
  });

  // Manual fromJson implementation
  factory UserPointsModel.fromJson(Map<String, dynamic> json) {
    return UserPointsModel(
      totalPoints: json['total_points'] ?? 0,
      currentPoints: json['current_points'] ?? 0,
      lastUpdated: _fromJsonTimestamp(
          json['last_updated'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Manual conversion to entity
  UserPoints toEntity() {
    return UserPoints(
      totalPoints: totalPoints,
      currentPoints: currentPoints,
      lastUpdated: lastUpdated,
    );
  }

  @override
  List<Object> get props => [totalPoints, currentPoints, lastUpdated];

  static DateTime _fromJsonTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    try {
      return DateTime.parse(timestamp.toString());
    } catch (_) {
      return DateTime.now();
    }
  }
}
