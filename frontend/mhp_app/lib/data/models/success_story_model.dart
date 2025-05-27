// lib/data/models/success_story_model.dart

import '../../domain/entities/success_story.dart';

class SuccessStoryModel extends SuccessStory {
  const SuccessStoryModel({
    required super.id,
    required super.title,
    required super.content,
    super.authorId,
    required super.authorName,
    required super.isAnonymous,
    required super.createdAt,
    required super.category,
    required super.encouragementCount,
    required super.hasEncouraged,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      id: json['id'].toString(),
      title: json['title'],
      content: json['content'],
      authorId: json['author']?.toString(),
      authorName: json['author_name'] ?? 'Anonymous',
      isAnonymous: json['is_anonymous'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      category: json['category'],
      encouragementCount: json['encouragement_count'] ?? 0,
      hasEncouraged: json['has_encouraged'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': authorId,
      'author_name': authorName,
      'is_anonymous': isAnonymous,
      'created_at': createdAt.toIso8601String(),
      'category': category,
      'encouragement_count': encouragementCount,
      'has_encouraged': hasEncouraged,
    };
  }
}
