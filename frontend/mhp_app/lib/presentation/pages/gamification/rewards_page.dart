// lib/presentation/pages/gamification/rewards_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      child: Scaffold(
        appBar: AppBar(title: const Text('Rewards')),
        body: Column(
          children: [
            _buildPointsHeader(context),
            Expanded(child: _buildRewardsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsHeader(BuildContext context) {
    return BlocBuilder<GamificationBloc, GamificationState>(
      buildWhen: (prev, curr) => curr is PointsLoaded || curr is PointsError,
      builder: (context, state) {
        if (state is PointsLoaded) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Available Points:', style: TextStyle(fontSize: 18)),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text('${state.points.currentPoints}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
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
