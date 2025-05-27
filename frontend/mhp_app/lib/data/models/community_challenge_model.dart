// lib/data/models/community_challenge_model.dart

import 'package:intl/intl.dart';
import '../../domain/entities/community_challenge.dart';

class CommunityChallengeModel extends CommunityChallenge {
  const CommunityChallengeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.goal,
    required super.startDate,
    required super.endDate,
    required super.createdById,
    required super.isActive,
    required super.createdAt,
    required super.challengeType,
    required super.participantCount,
    required super.isParticipating,
  });
  factory CommunityChallengeModel.fromJson(Map<String, dynamic> json) {
    final dateOnlyFormat = DateFormat("yyyy-MM-dd");
    final dateTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");

    return CommunityChallengeModel(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      goal: json['goal'],
      startDate: json['start_date'] != null
          ? dateOnlyFormat.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? dateOnlyFormat.parse(json['end_date'])
          : DateTime.now(),
      createdById: json['created_by']?.toString() ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null
          ? dateTimeFormat.parse(json['created_at'])
          : DateTime.now(),
      challengeType: json['challenge_type'] ?? '',
      participantCount: json['participant_count'] ?? 0,
      isParticipating: json['is_participating'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return {
      'id': id,
      'title': title,
      'description': description,
      'goal': goal,
      'start_date': dateFormat.format(startDate),
      'end_date': dateFormat.format(endDate),
      'created_by': createdById,
      'is_active': isActive,
      'created_at': dateFormat.format(createdAt),
      'challenge_type': challengeType,
      'participant_count': participantCount,
      'is_participating': isParticipating,
    };
  }
}
