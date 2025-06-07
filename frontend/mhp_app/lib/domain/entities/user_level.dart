// lib/domain/entities/user_level.dart
import 'dart:ui';

class UserLevel {
  final int level;
  final String title;
  final String description;
  final int pointsRequired;
  final String badgeImage;
  final List<String> perks; // Benefits unlocked at this level
  final Color color;

  const UserLevel({
    required this.level,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.badgeImage,
    required this.perks,
    required this.color,
  });
}
