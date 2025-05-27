// lib/data/models/discussion_group_model.dart

import '../../domain/entities/discussion_group.dart';

class DiscussionGroupModel extends DiscussionGroup {
  const DiscussionGroupModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.topicType,
    required super.isModerated,
    required super.createdAt,
    required super.memberCount,
    required super.threadCount,
    required super.isMember,
  });

  factory DiscussionGroupModel.fromJson(Map<String, dynamic> json) {
    return DiscussionGroupModel(
      id: json['id'].toString(),
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      topicType: json['topic_type'],
      isModerated: json['is_moderated'],
      createdAt: DateTime.parse(json['created_at']),
      memberCount: json['member_count'] ?? 0,
      threadCount: json['thread_count'] ?? 0,
      isMember: json['is_member'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'topic_type': topicType,
      'is_moderated': isModerated,
      'created_at': createdAt.toIso8601String(),
      'member_count': memberCount,
      'thread_count': threadCount,
      'is_member': isMember,
    };
  }
}
