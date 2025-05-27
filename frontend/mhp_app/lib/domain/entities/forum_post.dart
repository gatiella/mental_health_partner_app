// lib/domain/entities/forum_post.dart

import 'package:equatable/equatable.dart';

class ForumPost extends Equatable {
  final String id;
  final String threadId;
  final String content;
  final String? authorId;
  final String authorName;
  final bool isAnonymous;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int encouragementCount;
  final bool hasEncouraged;

  const ForumPost({
    required this.id,
    required this.threadId,
    required this.content,
    this.authorId,
    required this.authorName,
    required this.isAnonymous,
    required this.createdAt,
    required this.updatedAt,
    required this.encouragementCount,
    required this.hasEncouraged,
  });

  @override
  List<Object?> get props => [
        id,
        threadId,
        content,
        authorId,
        authorName,
        isAnonymous,
        createdAt,
        updatedAt,
        encouragementCount,
        hasEncouraged,
      ];
}
