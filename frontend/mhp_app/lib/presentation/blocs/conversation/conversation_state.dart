// conversation_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/message.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationsLoaded extends ConversationState {
  final List<Conversation> conversations;

  const ConversationsLoaded({required this.conversations});

  @override
  List<Object> get props => [conversations];
}

class ConversationStarted extends ConversationState {
  final Conversation conversation;

  const ConversationStarted({required this.conversation});

  @override
  List<Object> get props => [conversation];
}

class MessageSent extends ConversationState {
  final List<Message> messages;

  const MessageSent({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError({required this.message});

  @override
  List<Object> get props => [message];
}
