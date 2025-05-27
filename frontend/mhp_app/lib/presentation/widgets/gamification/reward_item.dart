// lib/presentation/widgets/gamification/reward_item.dart
import 'package:flutter/material.dart';
import '../../../../domain/entities/reward.dart';

class RewardItem extends StatelessWidget {
  final Reward reward;
  final VoidCallback onRedeem;

  const RewardItem({
    super.key,
    required this.reward,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: reward.image != null
            ? Image.asset(reward.image!, width: 50, height: 50)
            : const Icon(Icons.card_giftcard),
        title: Text(reward.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reward.description),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(' ${reward.pointsRequired}'),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onRedeem,
          child: const Text('Redeem'),
        ),
      ),
    );
  }
}
