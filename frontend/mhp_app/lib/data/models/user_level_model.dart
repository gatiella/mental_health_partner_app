// lib/data/models/user_level_model.dart
import 'dart:ui';
import 'package:mental_health_partner/domain/entities/user_level.dart';

class UserLevelModel extends UserLevel {
  const UserLevelModel({
    required super.level,
    required super.title,
    required super.description,
    required super.pointsRequired,
    required super.badgeImage,
    required super.perks,
    required super.color,
  });

  factory UserLevelModel.fromJson(Map<String, dynamic> json) {
    return UserLevelModel(
      level: json['level'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pointsRequired: json['pointsRequired'] ?? 0,
      badgeImage: json['badgeImage'] ?? '',
      perks: json['perks'] ?? [],
      color: Color(json['color'] ?? 0xFF6366F1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'title': title,
      'description': description,
      'pointsRequired': pointsRequired,
      'badgeImage': badgeImage,
      'perks': perks,
      'color': color.value,
    };
  }

  UserLevel toEntity() {
    return UserLevel(
      level: level,
      title: title,
      description: description,
      pointsRequired: pointsRequired,
      badgeImage: badgeImage,
      perks: perks,
      color: color,
    );
  }
}
