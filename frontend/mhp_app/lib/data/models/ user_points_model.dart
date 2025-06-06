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
      totalPoints: int.parse(json['total_points'].toString()),
      currentPoints: int.parse(json['current_points'].toString()),
      lastUpdated: DateTime.parse(
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

  Map<String, dynamic> toJson() {
    return {
      'total_points': totalPoints,
      'current_points': currentPoints,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [totalPoints, currentPoints, lastUpdated];
}
