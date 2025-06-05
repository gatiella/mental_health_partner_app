import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/gamification/gamification_bloc.dart';
import '../../../../domain/entities/quest.dart';

class QuestDetailPage extends StatefulWidget {
  final Quest quest;

  const QuestDetailPage({
    super.key,
    required this.quest,
  });

  @override
  _QuestDetailPageState createState() => _QuestDetailPageState();
}

class _QuestDetailPageState extends State<QuestDetailPage> {
  int? _moodBefore;
  int? _moodAfter;
  final TextEditingController _reflectionController = TextEditingController();
  int? _userQuestId;
  bool _isStarted = false;
  bool _isCompleted = false;

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quest.title),
      ),
      body: BlocConsumer<GamificationBloc, GamificationState>(
        listener: (context, state) {
          if (state is QuestStarted) {
            setState(() {
              _userQuestId = state.userQuest.id;
              _isStarted = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quest started!')),
            );
          } else if (state is QuestCompleted) {
            setState(() {
              _isCompleted = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Quest completed! +${state.pointsEarned} points'),
                duration: const Duration(seconds: 3),
              ),
            );

            // Show achievement dialog if any
            Future.delayed(const Duration(seconds: 1), () {
              context.read<GamificationBloc>().add(LoadEarnedAchievements());
            });
          } else if (state is StartQuestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error starting quest: ${state.message}')),
            );
          } else if (state is CompleteQuestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error completing quest: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          // Show loading indicator when starting or completing quest
          bool isLoading = state is StartingQuest || state is CompletingQuest;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed image loading section
                if (widget.quest.imageUrl != null &&
                    widget.quest.imageUrl!.isNotEmpty)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.quest.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  // Fallback placeholder when no image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getCategoryColor(widget.quest.category)
                              .withOpacity(0.3),
                          _getCategoryColor(widget.quest.category)
                              .withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getCategoryIcon(widget.quest.category),
                            size: 60,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.quest.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Quest info
                Text(
                  widget.quest.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Chip(
                      label: Text(widget.quest.category),
                      backgroundColor: _getCategoryColor(widget.quest.category),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('${widget.quest.durationMinutes} min'),
                      backgroundColor: Colors.blue[100],
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16),
                          const SizedBox(width: 4),
                          Text('${widget.quest.points}'),
                        ],
                      ),
                      backgroundColor: Colors.amber[100],
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Text(
                  widget.quest.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(widget.quest.instructions),

                const SizedBox(height: 32),

                // Quest action sections with loading states
                if (isLoading)
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Processing...'),
                      ],
                    ),
                  )
                else ...[
                  if (!_isStarted && !_isCompleted) _buildStartQuestSection(),
                  if (_isStarted && !_isCompleted) _buildCompleteQuestSection(),
                  if (_isCompleted) _buildCompletedSection(),
                ],

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStartQuestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How do you feel right now?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildMoodSelector(
          currentMood: _moodBefore,
          onSelect: (mood) {
            setState(() {
              _moodBefore = mood;
            });
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _moodBefore != null ? _startQuest : null,
            child: const Text('START QUEST'),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteQuestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reflection',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reflectionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'How was your experience? (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'How do you feel now?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildMoodSelector(
          currentMood: _moodAfter,
          onSelect: (mood) {
            setState(() {
              _moodAfter = mood;
            });
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _completeQuest,
            child: const Text('COMPLETE QUEST'),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quest Completed!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Great job! You\'ve earned ${widget.quest.points} points.',
                      style: TextStyle(color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('BACK TO QUESTS'),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSelector(
      {required int? currentMood, required Function(int) onSelect}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final mood = index + 1;
        final isSelected = currentMood == mood;

        return GestureDetector(
          onTap: () => onSelect(mood),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getMoodIcon(mood),
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(_getMoodText(mood)),
            ],
          ),
        );
      }),
    );
  }

  IconData _getMoodIcon(int mood) {
    switch (mood) {
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

  String _getMoodText(int mood) {
    switch (mood) {
      case 1:
        return 'Bad';
      case 2:
        return 'Poor';
      case 3:
        return 'OK';
      case 4:
        return 'Good';
      case 5:
        return 'Great';
      default:
        return '';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cbt':
        return Colors.purple[100]!;
      case 'mindfulness':
      case 'mindfulness & meditation':
        return Colors.teal[100]!;
      case 'activity':
        return Colors.orange[100]!;
      case 'social':
        return Colors.pink[100]!;
      case 'gratitude':
        return Colors.indigo[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cbt':
        return Icons.psychology;
      case 'mindfulness':
      case 'mindfulness & meditation':
        return Icons.self_improvement;
      case 'activity':
        return Icons.directions_run;
      case 'social':
        return Icons.people;
      case 'gratitude':
        return Icons.favorite;
      default:
        return Icons.star;
    }
  }

  void _startQuest() {
    if (_moodBefore != null) {
      context.read<GamificationBloc>().add(StartQuestEvent(
            questId: widget.quest.id,
            moodBefore: _moodBefore,
          ));
    }
  }

  void _completeQuest() {
    if (_userQuestId != null) {
      context.read<GamificationBloc>().add(CompleteQuestEvent(
            userQuestId: _userQuestId!,
            reflection: _reflectionController.text,
            moodAfter: _moodAfter,
          ));
    }
  }
}
