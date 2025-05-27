import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/conversation.dart';
import 'package:mental_health_partner/domain/usecases/conversation/get_conversation_history_usecase.dart';
import 'package:mental_health_partner/domain/usecases/conversation/send_message_usecase.dart';
import 'package:mental_health_partner/domain/usecases/conversation/start_conversation_usecase.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_event.dart';
import 'package:mental_health_partner/presentation/blocs/conversation/conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final GetConversations getConversations;
  final StartConversation startConversation;
  final SendMessage sendMessage;
  List<Conversation> _conversations = [];

  ConversationBloc({
    required this.getConversations,
    required this.startConversation,
    required this.sendMessage,
  }) : super(ConversationInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<StartNewConversation>(_onStartNewConversation);
    on<SendMessageEvent>(
        _onSendMessage as EventHandler<SendMessageEvent, ConversationState>);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());
    final result = await getConversations(NoParams());
    result.fold(
      (failure) => emit(ConversationError(message: failure.message)),
      (conversations) {
        _conversations = conversations;
        emit(ConversationsLoaded(conversations: _conversations));
      },
    );
  }

  Future<void> _onStartNewConversation(
    StartNewConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());
    final result = await startConversation(NoParams());
    result.fold(
      (failure) => emit(ConversationError(message: failure.message)),
      (conversation) {
        _conversations.add(conversation);
        emit(ConversationStarted(conversation: conversation));
        emit(ConversationsLoaded(conversations: _conversations));
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event, // Changed parameter type
    Emitter<ConversationState> emit,
  ) async {
    final result = await sendMessage(
      SendMessageParams(
        conversationId: event.conversationId, // Now accessible
        content: event.content, // Now accessible
      ),
    );

    result.fold(
      (failure) => emit(ConversationError(message: failure.message)),
      (messages) {
        // Find the conversation to update
        final conversationIndex = _conversations.indexWhere(
          (c) => c.id == event.conversationId,
        );

        if (conversationIndex != -1) {
          // Create a new conversation with updated messages
          final updatedConversation =
              _conversations[conversationIndex].copyWith(
            messages: [
              ..._conversations[conversationIndex].messages,
              ...messages
            ],
          );

          // Update the conversations list
          _conversations = List.from(_conversations)
            ..[conversationIndex] = updatedConversation;

          // Emit success states
          emit(MessageSent(messages: messages));
          emit(ConversationsLoaded(conversations: _conversations));
        } else {
          emit(const ConversationError(message: 'Conversation not found'));
        }
      },
    );
  }
}
