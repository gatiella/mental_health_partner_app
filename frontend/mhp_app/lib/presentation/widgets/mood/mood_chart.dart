import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';

class MoodChart extends StatelessWidget {
  final Map<String, dynamic> analyticsData;

  const MoodChart({
    super.key,
    required this.analyticsData,
  });

  @override
  Widget build(BuildContext context) {
    // Extract mood data from analytics
    final List<Map<String, dynamic>> moodData = _extractMoodData();

    // Make the widget scrollable to prevent overflow
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Use minimum space needed
          children: [
            // Fixed height for chart to prevent dynamic sizing issues
            SizedBox(
              height: 180,
              child: _buildMoodDistributionChart(moodData),
            ),
            const SizedBox(height: 16),
            _buildMoodLegend(),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _extractMoodData() {
    // Example data extraction - modify based on your actual data structure
    try {
      if (analyticsData.containsKey('moods') &&
          analyticsData['moods'] is List) {
        return List<Map<String, dynamic>>.from(analyticsData['moods']);
      }

      // Fallback sample data if structure doesn't match
      return [
        {'mood_type': 'happy', 'count': 2},
        {'mood_type': 'calm', 'count': 3},
        {'mood_type': 'neutral', 'count': 1},
      ];
    } catch (e) {
      // Return sample data on error
      return [
        {'mood_type': 'happy', 'count': 2},
        {'mood_type': 'calm', 'count': 1},
        {'mood_type': 'sad', 'count': 1},
      ];
    }
  }

  Widget _buildMoodDistributionChart(List<Map<String, dynamic>> moodData) {
    // Calculate total count for percentages
    int totalCount = 0;
    final Map<String, int> moodCounts = {};

    // Count occurrences of each mood type
    for (var mood in moodData) {
      final String moodType = mood['mood_type'] ?? 'unknown';
      final int count = mood['count'] ?? 1;

      if (moodCounts.containsKey(moodType)) {
        moodCounts[moodType] = moodCounts[moodType]! + count;
      } else {
        moodCounts[moodType] = count;
      }

      totalCount += count;
    }

    // Create pie chart sections
    final List<PieChartSectionData> sections = [];

    moodCounts.forEach((moodType, count) {
      final double percentage = totalCount > 0 ? (count / totalCount * 100) : 0;

      // Only show text on larger sections to prevent overlapping
      final bool showTitle = percentage > 5;

      sections.add(
        PieChartSectionData(
          color: _getMoodColor(moodType),
          value: percentage,
          title: showTitle ? '${percentage.toStringAsFixed(0)}%' : '',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
          ),
        ),
      );
    });

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 0,
        startDegreeOffset: -90,
      ),
    );
  }

  Widget _buildMoodLegend() {
    // Use LayoutBuilder to make legend responsive
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildLegendItem('Happy', AppColors.moodHappy),
            _buildLegendItem('Sad', AppColors.moodSad),
            _buildLegendItem('Angry', AppColors.moodAngry),
            _buildLegendItem('Neutral', AppColors.moodNeutral),
            _buildLegendItem('Calm', AppColors.moodCalm),
            _buildLegendItem('Anxious', AppColors.moodAnxious),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Color _getMoodColor(String moodType) {
    switch (moodType.toLowerCase()) {
      case 'happy':
        return AppColors.moodHappy;
      case 'sad':
        return AppColors.moodSad;
      case 'angry':
        return AppColors.moodAngry;
      case 'neutral':
        return AppColors.moodNeutral;
      case 'calm':
        return AppColors.moodCalm;
      case 'anxious':
        return AppColors.moodAnxious;
      default:
        return Colors.grey;
    }
  }
}
