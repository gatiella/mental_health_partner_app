import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String content;
  final bool isUserMessage;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.content,
    required this.isUserMessage,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, content, isUserMessage, createdAt];
}
