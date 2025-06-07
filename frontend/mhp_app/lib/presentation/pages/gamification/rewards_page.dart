// lib/presentation/pages/gamification/rewards_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/domain/repositories/level_repository.dart';
import 'package:mental_health_partner/presentation/widgets/gamification/level_progress_indicator.dart';
import '../../blocs/gamification/gamification_bloc.dart';
import '../../widgets/gamification/reward_item.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GamificationBloc>(context)
        ..add(LoadUserPoints())
        ..add(LoadRewards()),
      child: BlocListener<GamificationBloc, GamificationState>(
        listener: (context, state) {
          if (state is RewardRedeemed) {
            // Refresh data
            context.read<GamificationBloc>().add(LoadUserPoints());
            context.read<GamificationBloc>().add(LoadRewards());
            context.read<GamificationBloc>().add(LoadRedeemedRewards());

            // Show confirmation
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Reward Redeemed!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You redeemed: ${state.userReward.reward.title}'),
                    if (state.userReward.redemptionCode != null)
                      Text('Code: ${state.userReward.redemptionCode}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is RedeemRewardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Rewards'),
            actions: [
              IconButton(
                icon: const Icon(Icons.military_tech),
                onPressed: () => Navigator.pushNamed(context, '/levels'),
                tooltip: 'View Levels',
              ),
            ],
          ),
          body: Column(
            children: [
              _buildLevelProgressSection(context),
              _buildPointsHeader(context),
              Expanded(child: _buildRewardsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelProgressSection(BuildContext context) {
    final levelRepository = LevelRepository();

    return BlocBuilder<GamificationBloc, GamificationState>(
      buildWhen: (prev, curr) => curr is PointsLoaded || curr is PointsError,
      builder: (context, state) {
        if (state is PointsLoaded) {
          final userProgress =
              levelRepository.getUserProgress(state.points.currentPoints);

          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  userProgress.currentLevelData.color.withOpacity(0.8),
                  userProgress.currentLevelData.color.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: userProgress.currentLevelData.color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Level',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Level ${userProgress.currentLevel}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userProgress.currentLevelData.title,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${userProgress.currentLevel}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (userProgress.nextLevelData != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next: ${userProgress.nextLevelData!.title}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${userProgress.pointsToNextLevel} points to go',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LevelProgressIndicator(
                    progress: userProgress.progressPercentage,
                    color: Colors.white,
                    height: 6,
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      '🎉 Maximum Level Reached!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPointsHeader(BuildContext context) {
    return BlocBuilder<GamificationBloc, GamificationState>(
      buildWhen: (prev, curr) => curr is PointsLoaded || curr is PointsError,
      builder: (context, state) {
        if (state is PointsLoaded) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Available Points:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${state.points.currentPoints}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is PointsError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error loading points: ${state.message}'),
          );
        }
        return const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildRewardsList() {
    return BlocBuilder<GamificationBloc, GamificationState>(
      buildWhen: (prev, curr) => curr is RewardsLoaded || curr is RewardsError,
      builder: (context, state) {
        if (state is RewardsLoaded) {
          if (state.rewards.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No rewards available yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Keep earning points to unlock rewards!',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.rewards.length,
            itemBuilder: (context, index) {
              final reward = state.rewards[index];
              return RewardItem(
                reward: reward,
                onRedeem: () => _redeemReward(context, reward.id),
              );
            },
          );
        } else if (state is RewardsError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _redeemReward(BuildContext context, int rewardId) {
    context.read<GamificationBloc>().add(RedeemRewardEvent(rewardId: rewardId));
  }
}
