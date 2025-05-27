import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/gamification/gamification_bloc.dart';

class QuestIndicator extends StatelessWidget {
  const QuestIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamificationBloc, GamificationState>(
      builder: (context, state) {
        if (state is QuestsLoaded) {
          final activeQuests =
              state.quests.where((q) => !q.isCompleted).toList();
          if (activeQuests.isEmpty) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activeQuests
                  .map((quest) => LinearProgressIndicator(
                        value: quest.progress,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 10,
                      ))
                  .toList(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
