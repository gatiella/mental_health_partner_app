import 'package:dartz/dartz.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';
import '../../core/errors/failure.dart';

abstract class ConversationRepository {
  Future<Either<Failure, List<Conversation>>> getConversations();
  Future<Either<Failure, Conversation>> startConversation();
  Future<Either<Failure, List<Message>>> sendMessage(
      String conversationId, String content);
}
