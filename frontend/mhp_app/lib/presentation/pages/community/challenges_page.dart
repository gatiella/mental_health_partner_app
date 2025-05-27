import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_state.dart';
import 'package:mental_health_partner/presentation/pages/community/challenge_detail_page.dart';
import 'package:mental_health_partner/presentation/widgets/community/challenge_card.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Challenges'),
        elevation: 4,
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state is CommunityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChallengesLoaded) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                    itemCount: state.challenges.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final challenge = state.challenges[index];
                      return ChallengeCard(
                        challenge: challenge,
                        onJoin: () => context.read<CommunityBloc>().add(
                              JoinChallenge(challengeId: challenge.id),
                            ),
                        onComplete: () => context.read<CommunityBloc>().add(
                              CompleteChallenge(challengeId: challenge.id),
                            ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChallengeDetailPage(challenge: challenge),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is CommunityError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
