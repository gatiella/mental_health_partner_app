// lib/presentation/widgets/gamification/level_card.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/user_level.dart';

class LevelCard extends StatelessWidget {
  final UserLevel level;
  final bool isUnlocked;
  final bool isCurrent;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isCurrent
              ? LinearGradient(
                  colors: [
                    level.color.withOpacity(0.3),
                    level.color.withOpacity(0.1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color:
              isCurrent ? null : (isUnlocked ? Colors.white : Colors.grey[100]),
          border: Border.all(
            color: isCurrent
                ? level.color
                : (isUnlocked ? Colors.grey[300]! : Colors.grey[400]!),
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Level Badge
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? level.color.withOpacity(0.2)
                      : Colors.grey[300],
                  border: Border.all(
                    color: isUnlocked ? level.color : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isUnlocked
                      ? Text(
                          '${level.level}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: level.color,
                          ),
                        )
                      : Icon(
                          Icons.lock,
                          color: Colors.grey[600],
                          size: 28,
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Level Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          level.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                isUnlocked ? Colors.black87 : Colors.grey[600],
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: level.color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'CURRENT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.description,
                      style: TextStyle(
                        color: isUnlocked ? Colors.grey[700] : Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: isUnlocked ? Colors.amber : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${level.pointsRequired} points',
                          style: TextStyle(
                            fontSize: 12,
                            color: isUnlocked
                                ? Colors.amber[700]
                                : Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow/Status Icon
              Icon(
                isUnlocked ? Icons.check_circle : Icons.lock,
                color: isUnlocked ? Colors.green : Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
