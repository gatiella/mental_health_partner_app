import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';

class MoodChart extends StatelessWidget {
  final Map<String, dynamic> analyticsData;
  final List<dynamic>? moodHistory; // Make this optional

  const MoodChart({
    super.key,
    required this.analyticsData,
    this.moodHistory, // Make this optional
  });

  @override
  Widget build(BuildContext context) {
    // Extract mood data from actual user history
    final List<Map<String, dynamic>> moodData = _extractMoodDataFromHistory();

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

  List<Map<String, dynamic>> _extractMoodDataFromHistory() {
    try {
      // If moodHistory is provided, use it
      if (moodHistory != null && moodHistory!.isNotEmpty) {
        // Count mood ratings from actual history
        final Map<String, int> moodCounts = {};

        for (var mood in moodHistory!) {
          String moodType;
          int rating;

          // Handle different possible data structures
          if (mood is Map) {
            rating = mood['rating'] ?? mood['mood_rating'] ?? 3;
          } else {
            // If mood has a rating property directly
            rating = mood.rating ?? 3;
          }

          // Convert rating to mood type
          moodType = _ratingToMoodType(rating);

          moodCounts[moodType] = (moodCounts[moodType] ?? 0) + 1;
        }

        // Convert to list format
        return moodCounts.entries
            .map((entry) => {
                  'mood_type': entry.key,
                  'count': entry.value,
                })
            .toList();
      }

      // Fallback: try to extract from analyticsData
      // Check multiple possible keys for mood data
      final possibleKeys = [
        'moods',
        'mood_data',
        'mood_distribution',
        'weekly_ratings'
      ];

      for (String key in possibleKeys) {
        if (analyticsData.containsKey(key)) {
          final data = analyticsData[key];

          // Handle weekly_ratings format
          if (key == 'weekly_ratings' && data is List && data.isNotEmpty) {
            final Map<String, int> moodCounts = {};

            for (var rating in data) {
              int ratingValue;
              if (rating is Map) {
                ratingValue = rating['rating'] ?? rating['value'] ?? 3;
              } else if (rating is int) {
                ratingValue = rating;
              } else {
                ratingValue = 3;
              }

              String moodType = _ratingToMoodType(ratingValue);
              moodCounts[moodType] = (moodCounts[moodType] ?? 0) + 1;
            }

            return moodCounts.entries
                .map((entry) => {
                      'mood_type': entry.key,
                      'count': entry.value,
                    })
                .toList();
          }

          // Handle direct mood data format
          if (data is List && data.isNotEmpty) {
            return List<Map<String, dynamic>>.from(data);
          }
        }
      }

      // If no mood data found, return empty
      return [];
    } catch (e) {
      print('Error extracting mood data: $e'); // Debug print
      return [];
    }
  }

  String _ratingToMoodType(int rating) {
    switch (rating) {
      case 1:
        return 'sad';
      case 2:
        return 'anxious';
      case 3:
        return 'neutral';
      case 4:
        return 'calm';
      case 5:
        return 'happy';
      default:
        return 'neutral';
    }
  }

  Widget _buildMoodDistributionChart(List<Map<String, dynamic>> moodData) {
    // Debug: Print the analytics data structure
    print('Analytics Data Keys: ${analyticsData.keys.toList()}');
    print('Analytics Data: $analyticsData');
    print('Mood Data: $moodData');

    if (moodData.isEmpty) {
      return const Center(
        child: Text(
          'No mood data available',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondaryLight,
          ),
        ),
      );
    }

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
