import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/domain/entities/conversation.dart';
import 'package:mental_health_partner/domain/entities/message.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../datasources/local/conversation_local_data_source.dart';
import '../datasources/remote/conversation_remote_data_source.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;
  final ConversationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ConversationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteConversations = await remoteDataSource.getConversations();
        await localDataSource.cacheConversations(remoteConversations);
        // Map models to entities here
        final conversations =
            remoteConversations.map((model) => model.toEntity()).toList();
        return Right(conversations);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final localConversations =
            await localDataSource.getCachedConversations();
        // Map models to entities here
        final conversations =
            localConversations.map((model) => model.toEntity()).toList();
        return Right(conversations);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Conversation>> startConversation() async {
    if (await networkInfo.isConnected) {
      try {
        final conversationModel = await remoteDataSource.startConversation();
        // Convert model to entity
        return Right(conversationModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> sendMessage(
    String conversationId,
    String content,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final messageModels = await remoteDataSource.sendMessage(
          conversationId,
          content,
        );

        // Convert models to entities first
        final messages =
            messageModels.map((model) => model.toEntity()).toList();

        // Cache all messages at once using the interface method
        await localDataSource.cacheMessages(conversationId, messages);

        return Right(messages);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
