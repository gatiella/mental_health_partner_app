// lib/data/models/forum_post_model.dart

import '../../domain/entities/forum_post.dart';

class ForumPostModel extends ForumPost {
  const ForumPostModel({
    required super.id,
    required super.threadId,
    required super.content,
    super.authorId,
    required super.authorName,
    required super.isAnonymous,
    required super.createdAt,
    required super.updatedAt,
    required super.encouragementCount,
    required super.hasEncouraged,
  });

  factory ForumPostModel.fromJson(Map<String, dynamic> json) {
    return ForumPostModel(
      id: json['id'].toString(),
      threadId: json['thread'].toString(),
      content: json['content'],
      authorId: json['author']?.toString(),
      authorName: json['author_name'] ?? 'Anonymous',
      isAnonymous: json['is_anonymous'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      encouragementCount: json['encouragement_count'] ?? 0,
      hasEncouraged: json['has_encouraged'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thread': threadId,
      'content': content,
      'author': authorId,
      'author_name': authorName,
      'is_anonymous': isAnonymous,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'encouragement_count': encouragementCount,
      'has_encouraged': hasEncouraged,
    };
  }
}
