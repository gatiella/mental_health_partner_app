// lib/presentation/widgets/gamification/progress_indicator.dart
import 'package:flutter/material.dart';

class LevelProgressIndicator extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;

  const LevelProgressIndicator({
    super.key,
    required this.progress,
    this.color = Colors.blue,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: Colors.white.withOpacity(0.3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
