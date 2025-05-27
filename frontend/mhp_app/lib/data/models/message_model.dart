import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Equatable {
  final String id;
  final String content;
  final bool isUserMessage;
  final DateTime createdAt;
  final double? sentimentScore;
  final String? conversationId;

  const MessageModel({
    required this.id,
    required this.content,
    required this.isUserMessage,
    required this.createdAt,
    this.sentimentScore,
    this.conversationId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'].toString(),
      content: json['content'] ?? '',
      isUserMessage: json['sender'] == 'user',
      createdAt: DateTime.parse(json['created_at']),
      sentimentScore: json['sentiment_score'] != null
          ? (json['sentiment_score'] as num).toDouble()
          : null,
      conversationId: json['conversation_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_user_message': isUserMessage,
      'created_at': createdAt.toIso8601String(),
      'sentiment_score': sentimentScore,
      'conversation_id': conversationId,
    };
  }

  Message toEntity() {
    return Message(
      id: id,
      content: content,
      isUserMessage: isUserMessage,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        isUserMessage,
        createdAt,
        sentimentScore,
        conversationId,
      ];
}
