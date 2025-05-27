import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/di/injection_container.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_event.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_state.dart';
import '../../widgets/mood/mood_chart.dart';

class MoodHistoryPage extends StatelessWidget {
  const MoodHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood History')),
      body: BlocProvider(
        create: (context) => sl<MoodBloc>()..add(LoadMoodHistory()),
        child: BlocConsumer<MoodBloc, MoodState>(
          listener: (context, state) {
            // Optional: Handle side effects here (e.g. show error dialog)
          },
          builder: (context, state) {
            if (state is MoodInitial) {
              return const Center(child: Text("Loading..."));
            }
            if (state is MoodError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            if (state is MoodHistoryLoaded) {
              final analyticsData = state.analytics;
              final hasHistoryData = state.history.isNotEmpty;

              return Column(
                children: [
                  // Chart Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        height: 250,
                        padding: const EdgeInsets.only(top: 8),
                        child: hasHistoryData
                            ? MoodChart(
                                analyticsData: analyticsData,
                                moodHistory:
                                    state.history, // Pass real mood history
                              )
                            : const Center(
                                child: Text("No mood data available"),
                              ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // Mood History List
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.history.length,
                      itemBuilder: (context, index) {
                        final mood = state.history[index];
                        return ListTile(
                          leading: Icon(
                            Icons.sentiment_satisfied,
                            color: _getMoodColor(mood.rating),
                          ),
                          title: Text(mood.notes ?? ''),
                          subtitle: Text(_formatDate(mood.timestamp)),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Color _getMoodColor(int rating) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green,
    ];
    return colors[rating.clamp(1, 5) - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
