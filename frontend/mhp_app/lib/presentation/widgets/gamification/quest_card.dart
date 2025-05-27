import 'package:flutter/material.dart';
import '../../../../domain/entities/quest.dart';
import 'progress_indicator.dart'; // Add this import

class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback onTap;

  const QuestCard({
    super.key,
    required this.quest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (quest.image != null && quest.image!.isNotEmpty)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  quest.image!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quest.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        _getCategoryName(quest.category),
                        _getCategoryColor(quest.category),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Row(
                          children: [
                            const Icon(Icons.timer, size: 16),
                            Text(' ${quest.durationMinutes}m'),
                          ],
                        ),
                        backgroundColor: Colors.blue[50],
                      ),
                      const SizedBox(width: 8),
                      CustomProgressIndicator(
                        value: quest.difficulty / 5,
                        color: _getCategoryColor(quest.category),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String text, Color color) {
    return Chip(
      label: Text(text),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide.none,
    );
  }

  String _getCategoryName(String categoryKey) {
    switch (categoryKey) {
      case 'cbt':
        return 'CBT';
      case 'mindfulness':
        return 'Mindfulness';
      case 'activity':
        return 'Activity';
      case 'social':
        return 'Social';
      case 'gratitude':
        return 'Gratitude';
      default:
        return 'General';
    }
  }

  Color _getCategoryColor(String categoryKey) {
    switch (categoryKey) {
      case 'cbt':
        return Colors.purple;
      case 'mindfulness':
        return Colors.teal;
      case 'activity':
        return Colors.orange;
      case 'social':
        return Colors.pink;
      case 'gratitude':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
