import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_event.dart';
import 'package:mental_health_partner/presentation/blocs/journal/journal_state.dart';
import 'package:mental_health_partner/presentation/widgets/common/app_button.dart';
import '../../widgets/journal/mood_emoji_selector.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedMood = 'Neutral';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Journal Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<JournalBloc, JournalState>(
          listener: (context, state) {
            if (state is JournalEntryAdded) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(labelText: 'Content'),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  MoodEmojiSelector(
                    selectedMood: _selectedMood,
                    onMoodSelected: (mood) =>
                        setState(() => _selectedMood = mood),
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    text: 'Save Entry',
                    onPressed: state is JournalLoading
                        ? null
                        : () {
                            // Validate all fields first
                            final errors = <String>[];
                            if (_titleController.text.isEmpty) {
                              errors.add('Title is required');
                            }
                            if (_contentController.text.isEmpty) {
                              errors.add('Content is required');
                            }
                            if (_selectedMood.isEmpty) {
                              errors.add('Please select a mood');
                            }

                            if (errors.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errors.join('\n')),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            // Only dispatch event if validation passes
                            context.read<JournalBloc>().add(
                                  AddJournalEntry(
                                    title: _titleController.text.trim(),
                                    content: _contentController.text.trim(),
                                    mood: _selectedMood,
                                  ),
                                );
                          },
                    isLoading: state is JournalLoading,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
