import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/config/routes.dart';
import 'package:mental_health_partner/di/injection_container.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_event.dart';
import 'package:mental_health_partner/presentation/blocs/mood/mood_state.dart';
import 'package:mental_health_partner/presentation/widgets/common/app_button.dart';
import 'package:mental_health_partner/presentation/widgets/mood/mood_picker.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';

class MoodInputPage extends StatelessWidget {
  const MoodInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoodBloc>(
      create: (context) => sl<MoodBloc>(),
      child: const _MoodInputPageContent(),
    );
  }
}

class _MoodInputPageContent extends StatefulWidget {
  const _MoodInputPageContent();

  @override
  State<_MoodInputPageContent> createState() => _MoodInputPageContentState();
}

class _MoodInputPageContentState extends State<_MoodInputPageContent> {
  int _selectedRating = 3;
  final _notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  void dispose() {
    _notesController.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(isDark),
      body: BlocConsumer<MoodBloc, MoodState>(
        listener: (context, state) {
          if (state is MoodRecorded) {
            Navigator.of(context).pop();
            _showConfirmationSnackbar(context);
          }
        },
        builder: (context, state) {
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      _buildHeader(theme, isDark),
                      const SizedBox(height: 40),
                      MoodPicker(
                        selectedRating: _selectedRating,
                        onMoodSelected: (rating) =>
                            setState(() => _selectedRating = rating),
                      ),
                      const SizedBox(height: 40),
                      _buildNotesField(theme, isDark),
                      const SizedBox(height: 24),
                      _buildHistoryButton(context, isDark),
                      const SizedBox(height: 40),
                      _buildSaveButton(state, context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      title: const Text('Record Mood'),
      shadowColor: Colors.black.withOpacity(0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.insights_rounded, size: 24),
            ),
            tooltip: 'Mood History',
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.moodHistoryRoute),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.self_improvement_rounded,
              size: 64, color: AppColors.primaryColor),
        ),
        const SizedBox(height: 24),
        Text(
          'How are you feeling today?',
          style: theme.textTheme.headlineSmall?.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Take a moment to reflect on your current emotional state. '
            'Your honest input helps us provide better support.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField(ThemeData theme, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark.withOpacity(0.9) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(_notesFocusNode.hasFocus ? 0.1 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: _notesFocusNode.hasFocus
            ? Border.all(color: AppColors.primaryColor.withOpacity(0.3))
            : null,
      ),
      child: TextField(
        controller: _notesController,
        focusNode: _notesFocusNode,
        decoration: InputDecoration(
          labelText: 'Journal your thoughts...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          labelStyle: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
          hintText: 'Example: "Today I felt excited about..."',
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark.withOpacity(0.6)
                : AppColors.textSecondaryLight.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
        style: TextStyle(
          color:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          height: 1.4,
        ),
        maxLines: 5,
        minLines: 3,
        textInputAction: TextInputAction.newline,
      ),
    );
  }

  Widget _buildHistoryButton(BuildContext context, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.primaryDarkColor.withOpacity(0.1),
                ],
              )
            : null,
      ),
      // child: OutlinedButton.icon(
      //   icon: const Icon(Icons.insights_rounded, size: 20),
      //   label: const Text('View Mood Insights'),
      //   style: OutlinedButton.styleFrom(
      //     foregroundColor: AppColors.primaryColor,
      //     side: BorderSide(
      //       color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.3),
      //     ),
      //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //     backgroundColor: isDark ? Colors.transparent : null,
      //   ),
      //   onPressed: () =>
      //       Navigator.pushNamed(context, AppRouter.moodHistoryRoute),
      // ),
    );
  }

  Widget _buildSaveButton(MoodState state, BuildContext context) {
    return AppButton(
      text: 'Save Mood Entry',
      icon: const Icon(Icons.save_rounded),
      onPressed: state is MoodLoading
          ? null
          : () => context.read<MoodBloc>().add(
                RecordMood(
                  rating: _selectedRating,
                  notes: _notesController.text.trim(),
                ),
              ),
      isLoading: state is MoodLoading,
      gradient: const LinearGradient(
        colors: [
          AppColors.primaryColor,
          AppColors.primaryDarkColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      elevation: 4,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
    );
  }

  void _showConfirmationSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mood entry saved successfully!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
