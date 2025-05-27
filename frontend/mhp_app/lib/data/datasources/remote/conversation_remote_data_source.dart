import 'package:dio/dio.dart';
import 'package:mental_health_partner/config/api_config.dart';
import 'package:mental_health_partner/core/errors/exceptions.dart';
import 'package:mental_health_partner/data/models/conversation_model.dart';
import 'package:mental_health_partner/data/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConversationRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<ConversationModel> startConversation();
  Future<List<MessageModel>> sendMessage(String conversationId, String content);
}

class ConversationRemoteDataSourceImpl implements ConversationRemoteDataSource {
  final Dio dio;
  final SharedPreferences prefs;

  ConversationRemoteDataSourceImpl({
    required this.dio,
    required this.prefs,
  });

  @override
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await dio.get(
        ApiConfig.conversations,
        options: Options(extra: {'refreshable': true}),
      );

      List<ConversationModel> fullConversations = [];

      if (response.data is List) {
        for (final item in response.data) {
          final detailRes =
              await dio.get('${ApiConfig.conversations}/${item['id']}');
          fullConversations.add(ConversationModel.fromJson(detailRes.data));
        }
      } else if (response.data is Map<String, dynamic> &&
          response.data.containsKey('results')) {
        for (final item in response.data['results']) {
          final detailRes =
              await dio.get('${ApiConfig.conversations}/${item['id']}');
          fullConversations.add(ConversationModel.fromJson(detailRes.data));
        }
      } else {
        throw ServerException(message: 'Unexpected response format');
      }

      return fullConversations;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to fetch conversations: ${e.response?.statusCode}',
      );
    }
  }

  @override
  Future<ConversationModel> startConversation() async {
    try {
      final response = await dio.post(
        ApiConfig.conversations,
        options: Options(extra: {'refreshable': true}),
      );
      return ConversationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to start conversation: ${e.response?.statusCode}',
      );
    }
  }

  @override
  Future<List<MessageModel>> sendMessage(
      String conversationId, String content) async {
    try {
      final response = await dio.post(
        ApiConfig.sendMessage(conversationId),
        data: {'content': content},
        options: Options(extra: {'refreshable': true}),
      );
      final responseBody = response.data;
      List<MessageModel> messages = [];
      if (responseBody.containsKey('user_message')) {
        messages.add(MessageModel.fromJson({
          ...responseBody['user_message'],
          'conversation_id': conversationId
        }));
      }
      if (responseBody.containsKey('ai_message')) {
        messages.add(MessageModel.fromJson({
          ...responseBody['ai_message'],
          'conversation_id': conversationId
        }));
      }
      return messages;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to send message: ${e.response?.statusCode}',
      );
    }
  }
}
