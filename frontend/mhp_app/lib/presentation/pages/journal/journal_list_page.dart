import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/config/routes.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_event.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_state.dart';
import 'package:mental_health_partner/presentation/widgets/journal/journal_card.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';

class JournalListPage extends StatelessWidget {
  const JournalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(isDark),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor,
        elevation: 4,
        tooltip: 'Add Journal Entry',
        onPressed: () =>
            Navigator.pushNamed(context, AppRouter.addJournalRoute),
        child: const Icon(Icons.add, size: 28),
      ),
      body: BlocListener<JournalBloc, JournalState>(
        listener: (context, state) {
          if (state is JournalEntryAdded) {
            context.read<JournalBloc>().add(LoadJournalEntries());
          }
        },
        child: BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            final textColor = isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          AppColors.backgroundDark,
                          AppColors.backgroundDark.withOpacity(0.95),
                        ]
                      : [
                          AppColors.backgroundLight,
                          AppColors.primaryLightColor.withOpacity(0.1),
                        ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: state is JournalEntriesLoaded
                      ? state.entries.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.menu_book_rounded,
                                      size: 64, color: textColor),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No journal entries yet.',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap the + button to add your first entry.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async => context
                                  .read<JournalBloc>()
                                  .add(LoadJournalEntries()),
                              child: ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                itemCount: state.entries.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final entry = state.entries[index];
                                  return Dismissible(
                                    key: ValueKey(entry.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      alignment: Alignment.centerRight,
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                    confirmDismiss: (direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Delete Entry?'),
                                          content: const Text(
                                            'Are you sure you want to delete this journal entry?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onDismissed: (_) {
                                      context
                                          .read<JournalBloc>()
                                          .add(DeleteJournalEntry(entry.id));

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Journal entry deleted'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    },
                                    child: Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(12),
                                      child: JournalCard(
                                        entry: entry,
                                        onDelete: () => context
                                            .read<JournalBloc>()
                                            .add(DeleteJournalEntry(entry.id)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      title: const Text('My Journal'),
      backgroundColor:
          isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
      foregroundColor:
          isDark ? AppColors.textPrimaryDark : AppColors.surfaceLight,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }
}
