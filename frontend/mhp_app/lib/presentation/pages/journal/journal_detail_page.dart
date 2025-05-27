import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_event.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_state.dart';
import 'package:mental_health_partner/presentation/widgets/common/loading_indicator.dart';
import '../../widgets/journal/journal_card.dart';

class JournalDetailPage extends StatelessWidget {
  final String journalId;

  const JournalDetailPage({super.key, required this.journalId});

  @override
  Widget build(BuildContext context) {
    // Dispatch event to load the specific journal entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JournalBloc>().add(LoadJournalEntry(journalId));
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Journal Entry')),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalLoading) {
            return const LoadingIndicator();
          } else if (state is JournalEntryLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: JournalCard(
                entry: state.entry,
                onDelete: () => context.read<JournalBloc>().add(
                      DeleteJournalEntry(state.entry.id),
                    ),
              ),
            );
          } else if (state is JournalError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const LoadingIndicator();
        },
      ),
    );
  }
}
