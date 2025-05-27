// lib/domain/entities/discussion_group.dart

import 'package:equatable/equatable.dart';

class DiscussionGroup extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String topicType;
  final bool isModerated;
  final DateTime createdAt;
  final int memberCount;
  final int threadCount;
  final bool isMember;

  const DiscussionGroup({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.topicType,
    required this.isModerated,
    required this.createdAt,
    required this.memberCount,
    required this.threadCount,
    required this.isMember,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        topicType,
        isModerated,
        createdAt,
        memberCount,
        threadCount,
        isMember,
      ];
}
