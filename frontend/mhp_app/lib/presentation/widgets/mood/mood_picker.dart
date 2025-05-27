// Enhanced MoodPicker
import 'package:flutter/material.dart';

class MoodPicker extends StatefulWidget {
  final ValueChanged<int> onMoodSelected;
  final int selectedRating;

  const MoodPicker({
    super.key,
    required this.onMoodSelected,
    required this.selectedRating,
  });

  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getMoodIcon(int rating) {
    switch (rating) {
      case 1:
        return Icons.sentiment_very_dissatisfied;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_satisfied;
      case 5:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final rating = index + 1;
        final isSelected = rating == widget.selectedRating;

        return GestureDetector(
          onTap: () {
            widget.onMoodSelected(rating);
            _controller.forward().then((_) => _controller.reverse());
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
                      parent: _controller, curve: Curves.easeOut)),
                  child: Icon(
                    _getMoodIcon(rating),
                    size: 42,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ['Poor', 'Low', 'Okay', 'Good', 'Great'][index],
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[600],
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
