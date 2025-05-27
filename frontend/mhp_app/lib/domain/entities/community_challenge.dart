// lib/domain/entities/community_challenge.dart

import 'package:equatable/equatable.dart';

class CommunityChallenge extends Equatable {
  final String id;
  final String title;
  final String description;
  final String goal;
  final DateTime startDate;
  final DateTime endDate;
  final String createdById;
  final bool isActive;
  final DateTime createdAt;
  final String challengeType;
  final int participantCount;
  final bool isParticipating;

  const CommunityChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.startDate,
    required this.endDate,
    required this.createdById,
    required this.isActive,
    required this.createdAt,
    required this.challengeType,
    required this.participantCount,
    required this.isParticipating,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        goal,
        startDate,
        endDate,
        createdById,
        isActive,
        createdAt,
        challengeType,
        participantCount,
        isParticipating,
      ];
}
