import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/message.dart';
import 'package:mental_health_partner/domain/repositories/conversation_repository.dart';
import 'package:equatable/equatable.dart';

class SendMessage implements UseCase<List<Message>, SendMessageParams> {
  final ConversationRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      // Correct method name
      params.conversationId,
      params.content,
    );
  }
}

class SendMessageParams extends Equatable {
  final String conversationId;
  final String content;

  const SendMessageParams({
    required this.conversationId,
    required this.content,
  });

  @override
  List<Object> get props => [conversationId, content];
}
