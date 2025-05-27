class Achievement {
  final int id;
  final String title;
  final String description;
  final String? category;
  final String badgeImage;
  final int points;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    required this.badgeImage,
    required this.points,
  });
}

class UserAchievement {
  final int id;
  final Achievement achievement;
  final DateTime earnedAt;

  UserAchievement({
    required this.id,
    required this.achievement,
    required this.earnedAt,
  });
}
