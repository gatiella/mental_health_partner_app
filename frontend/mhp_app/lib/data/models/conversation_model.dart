import 'package:equatable/equatable.dart';
import '../../domain/entities/conversation.dart';
import 'message_model.dart';

class ConversationModel extends Equatable {
  final String id;
  final List<MessageModel> messages;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ConversationModel({
    required this.id,
    required this.messages,
    required this.createdAt,
    this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'].toString(),
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((m) => MessageModel.fromJson(
                  {...m, 'conversation_id': json['id'].toString()}))
              .toList()
          : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Conversation toEntity() {
    return Conversation(
      id: id,
      messages: messages.map((m) => m.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ConversationModel copyWith({
    String? id,
    List<MessageModel>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, messages, createdAt, updatedAt];
}
