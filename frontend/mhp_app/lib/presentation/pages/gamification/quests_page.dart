import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/pages/gamification/quest_detail_page.dart';
import '../../blocs/gamification/gamification_bloc.dart';
import '../../widgets/gamification/quest_card.dart';
import '../../../../domain/entities/quest.dart';

class QuestsPage extends StatefulWidget {
  const QuestsPage({super.key});

  @override
  _QuestsPageState createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRetryingRecommended = false;
  bool _isRetryingAll = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load quests and points when page is opened
    _loadData();
  }

  void _loadData() {
    context.read<GamificationBloc>().add(LoadQuests());
    context.read<GamificationBloc>().add(LoadRecommendedQuests());
    context.read<GamificationBloc>().add(LoadUserPoints());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recommended'),
            Tab(text: 'All Quests'),
          ],
        ),
        actions: [
          BlocBuilder<GamificationBloc, GamificationState>(
            buildWhen: (previous, current) =>
                current is PointsLoaded || current is PointsLoading,
            builder: (context, state) {
              if (state is PointsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${state.points.currentPoints}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Recommended Quests
          BlocBuilder<GamificationBloc, GamificationState>(
            buildWhen: (previous, current) =>
                current is RecommendedQuestsLoading ||
                current is RecommendedQuestsLoaded ||
                current is RecommendedQuestsError,
            builder: (context, state) {
              if (state is RecommendedQuestsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RecommendedQuestsLoaded) {
                _isRetryingRecommended = false;
                return _buildQuestList(state.quests);
              } else if (state is RecommendedQuestsError) {
                return _buildErrorView(
                  state.message,
                  isRetrying: _isRetryingRecommended,
                  onRetry: () {
                    setState(() {
                      _isRetryingRecommended = true;
                    });
                    context
                        .read<GamificationBloc>()
                        .add(LoadRecommendedQuests());
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted && _isRetryingRecommended) {
                        setState(() {
                          _isRetryingRecommended = false;
                        });
                      }
                    });
                  },
                );
              }
              return _buildEmptyView('No recommended quests available');
            },
          ),

          // Tab 2: All Quests
          BlocBuilder<GamificationBloc, GamificationState>(
            buildWhen: (previous, current) =>
                current is QuestsLoading ||
                current is QuestsLoaded ||
                current is QuestsError,
            builder: (context, state) {
              if (state is QuestsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is QuestsLoaded) {
                _isRetryingAll = false;
                return _buildQuestList(state.quests);
              } else if (state is QuestsError) {
                return _buildErrorView(
                  state.message,
                  isRetrying: _isRetryingAll,
                  onRetry: () {
                    setState(() {
                      _isRetryingAll = true;
                    });
                    context.read<GamificationBloc>().add(LoadQuests());
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted && _isRetryingAll) {
                        setState(() {
                          _isRetryingAll = false;
                        });
                      }
                    });
                  },
                );
              }
              return _buildEmptyView('No quests available');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestList(List<Quest> quests) {
    if (quests.isEmpty) {
      return _buildEmptyView('No quests available');
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadData();
        // Wait a bit to give the refresh indicator time to show
        await Future.delayed(const Duration(milliseconds: 800));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quests.length,
        itemBuilder: (context, index) {
          final quest = quests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: QuestCard(
              quest: quest,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestDetailPage(quest: quest),
                  ),
                ).then((_) {
                  // Refresh data when returning from detail page
                  _loadData();
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message,
      {required bool isRetrying, required VoidCallback onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isRetrying ? null : onRetry,
              child: isRetrying
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Retrying...'),
                      ],
                    )
                  : const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
