import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/usecases/usecase.dart';
import 'package:mental_health_partner/domain/entities/conversation.dart';
import 'package:mental_health_partner/domain/repositories/conversation_repository.dart';

class GetConversations implements UseCase<List<Conversation>, NoParams> {
  final ConversationRepository repository;

  GetConversations(this.repository);

  @override
  Future<Either<Failure, List<Conversation>>> call(NoParams params) async {
    return await repository.getConversations();
  }
}
