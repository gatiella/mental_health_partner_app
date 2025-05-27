class Quest {
  final int id;
  final String title;
  final String description;
  final String category;
  final int points;
  final int durationMinutes;
  final String instructions;
  final int difficulty;
  final String? image;
  final bool isCompleted;
  final double progress;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.points,
    required this.durationMinutes,
    required this.instructions,
    required this.difficulty,
    this.image,
    required this.isCompleted,
    required this.progress,
  });
}

class UserQuest {
  final int id;
  final Quest quest;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;
  final String? reflection;
  final int? moodBefore;
  final int? moodAfter;

  UserQuest({
    required this.id,
    required this.quest,
    required this.startedAt,
    this.completedAt,
    required this.isCompleted,
    this.reflection,
    this.moodBefore,
    this.moodAfter,
  });
}
