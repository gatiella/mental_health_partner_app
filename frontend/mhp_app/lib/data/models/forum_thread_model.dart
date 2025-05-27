import '../../domain/entities/forum_thread.dart';
import 'forum_post_model.dart';

class ForumThreadModel extends ForumThread {
  const ForumThreadModel({
    required super.id,
    required super.title,
    required super.discussionGroupId,
    super.createdById,
    required super.authorName,
    required super.isAnonymous,
    required super.isPinned,
    required super.isLocked,
    required super.createdAt,
    required super.updatedAt,
    required super.postCount,
    required super.lastPostAt,
    super.posts = const [],
  });

  factory ForumThreadModel.fromJson(Map<String, dynamic> json) {
    return ForumThreadModel(
      id: json['id'].toString(),
      title: json['title'],
      discussionGroupId: json['discussion_group'].toString(),
      createdById: json['created_by']?.toString(),
      authorName: json['author'] ?? 'Anonymous',
      isAnonymous: json['is_anonymous'] ?? false,
      isPinned: json['is_pinned'] ?? false,
      isLocked: json['is_locked'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      postCount: json['post_count'] ?? 0,
      lastPostAt: json['last_post_at'] != null
          ? DateTime.parse(json['last_post_at'])
          : DateTime.parse(json['created_at']),
      posts: json['posts'] != null
          ? (json['posts'] as List)
              .map((e) => ForumPostModel.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'discussion_group': discussionGroupId,
      'created_by': createdById,
      'author': authorName,
      'is_anonymous': isAnonymous,
      'is_pinned': isPinned,
      'is_locked': isLocked,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'post_count': postCount,
      'last_post_at': lastPostAt.toIso8601String(),
      'posts': posts.map((e) => (e as ForumPostModel).toJson()).toList(),
    };
  }
}
