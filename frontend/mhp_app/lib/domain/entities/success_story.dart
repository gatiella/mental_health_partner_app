import 'package:equatable/equatable.dart';

class SuccessStory extends Equatable {
  final String id;
  final String title;
  final String content;
  final String? authorId;
  final String authorName;
  final bool isAnonymous;
  final DateTime createdAt;
  final String category;
  final int encouragementCount;
  final bool hasEncouraged;

  const SuccessStory({
    required this.id,
    required this.title,
    required this.content,
    this.authorId,
    required this.authorName,
    required this.isAnonymous,
    required this.createdAt,
    required this.category,
    required this.encouragementCount,
    required this.hasEncouraged,
  });

  SuccessStory copyWith({
    String? title,
    String? content,
    String? authorId,
    String? authorName,
    bool? isAnonymous,
    DateTime? createdAt,
    String? category,
    int? encouragementCount,
    bool? hasEncouraged,
  }) {
    return SuccessStory(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      encouragementCount: encouragementCount ?? this.encouragementCount,
      hasEncouraged: hasEncouraged ?? this.hasEncouraged,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        authorId,
        authorName,
        isAnonymous,
        createdAt,
        category,
        encouragementCount,
        hasEncouraged,
      ];
}
