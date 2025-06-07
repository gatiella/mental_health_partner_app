import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/data/repositories/level_service.dart';
import 'package:mental_health_partner/domain/repositories/level_repository.dart';
import 'package:mental_health_partner/presentation/blocs/gamification/gamification_bloc.dart';

class LevelRestrictedContent extends StatelessWidget {
  final Widget child;
  final String feature;
  final int requiredLevel;
  final String lockMessage;

  const LevelRestrictedContent({
    super.key,
    required this.child,
    required this.feature,
    required this.requiredLevel,
    required this.lockMessage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamificationBloc, GamificationState>(
      buildWhen: (prev, curr) => curr is PointsLoaded,
      builder: (context, state) {
        if (state is PointsLoaded) {
          final levelService = LevelService(
            levelRepository: LevelRepository(),
            gamificationBloc: context.read<GamificationBloc>(),
          );

          if (levelService.canAccessFeature(
              state.points.currentPoints, feature)) {
            return child;
          } else {
            return _buildLockedContent();
          }
        }
        return child; // Show content while loading
      },
    );
  }

  Widget _buildLockedContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            'Level $requiredLevel Required',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lockMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to levels page or show level info
            },
            icon: const Icon(Icons.military_tech),
            label: const Text('View Levels'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
