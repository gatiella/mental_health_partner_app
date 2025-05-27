import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/conversation.dart';
import 'package:mental_health_partner/domain/repositories/conversation_repository.dart';

class StartConversation implements UseCase<Conversation, NoParams> {
  final ConversationRepository repository;

  StartConversation(this.repository);

  @override
  Future<Either<Failure, Conversation>> call(NoParams params) async {
    return await repository.startConversation();
  }
}
