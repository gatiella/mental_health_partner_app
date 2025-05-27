// lib/presentation/widgets/gamification/achievement_badge.dart
import 'package:flutter/material.dart';
import '../../../../domain/entities/achievement.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final bool earned;
  final VoidCallback onTap;

  const AchievementBadge({
    super.key,
    required this.achievement,
    required this.earned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: earned ? 1.0 : 0.3,
        child: Column(
          children: [
            Image.asset(
              achievement.badgeImage,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: earned ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!earned)
              const Text(
                'Locked',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
