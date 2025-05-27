import 'package:flutter/material.dart';

class MoodEmojiSelector extends StatelessWidget {
  final String selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodEmojiSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final moods = {
      '😊': 'Happy',
      '😐': 'Neutral',
      '😞': 'Sad',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Mood:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: moods.entries.map((entry) {
            return ChoiceChip(
              label: Text('${entry.key} ${entry.value}'),
              selected: selectedMood == entry.value,
              onSelected: (_) => onMoodSelected(entry.value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
