import 'package:equatable/equatable.dart';
import 'forum_post.dart';

class ForumThread extends Equatable {
  final String id;
  final String title;
  final String discussionGroupId;
  final String? createdById;
  final String authorName;
  final bool isAnonymous;
  final bool isPinned;
  final bool isLocked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int postCount;
  final DateTime lastPostAt;
  final List<ForumPost> posts;

  const ForumThread({
    required this.id,
    required this.title,
    required this.discussionGroupId,
    this.createdById,
    required this.authorName,
    required this.isAnonymous,
    required this.isPinned,
    required this.isLocked,
    required this.createdAt,
    required this.updatedAt,
    required this.postCount,
    required this.lastPostAt,
    this.posts = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        discussionGroupId,
        createdById,
        authorName,
        isAnonymous,
        isPinned,
        isLocked,
        createdAt,
        updatedAt,
        postCount,
        lastPostAt,
        posts,
      ];
}
