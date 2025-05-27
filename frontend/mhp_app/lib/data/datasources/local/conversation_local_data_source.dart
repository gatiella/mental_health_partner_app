import 'dart:convert';
import 'package:mental_health_partner/core/errors/exceptions.dart';
import 'package:mental_health_partner/data/models/conversation_model.dart';
import 'package:mental_health_partner/data/models/message_model.dart';
import 'package:mental_health_partner/domain/entities/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConversationLocalDataSource {
  Future<List<ConversationModel>> getCachedConversations();
  Future<void> cacheConversations(List<ConversationModel> conversations);
  Future<void> cacheMessages(String conversationId, List<Message> messages);
}

class ConversationLocalDataSourceImpl implements ConversationLocalDataSource {
  final SharedPreferences sharedPreferences;
  // ignore: constant_identifier_names
  static const String CACHED_CONVERSATIONS_KEY = 'CACHED_CONVERSATIONS';
  // ignore: constant_identifier_names
  static const String CACHED_MESSAGES_PREFIX = 'CACHED_MESSAGES_';

  ConversationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ConversationModel>> getCachedConversations() async {
    final jsonString = sharedPreferences.getString(CACHED_CONVERSATIONS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((jsonMap) => ConversationModel.fromJson(jsonMap))
          .toList();
    } else {
      throw CacheException(message: 'No cached conversations found');
    }
  }

  @override
  Future<void> cacheConversations(List<ConversationModel> conversations) async {
    final List<Map<String, dynamic>> jsonList =
        conversations.map((conversation) => conversation.toJson()).toList();
    await sharedPreferences.setString(
      CACHED_CONVERSATIONS_KEY,
      json.encode(jsonList),
    );
  }

  @override
  Future<void> cacheMessages(
      String conversationId, List<Message> messages) async {
    final key = '$CACHED_MESSAGES_PREFIX$conversationId';

    // Convert each Message (domain entity) to MessageModel for JSON conversion
    final messageModels = messages.map((m) {
      return MessageModel(
        id: m.id,
        content: m.content,
        isUserMessage: m.isUserMessage,
        createdAt: m.createdAt,
        sentimentScore: null, // or add if available in Message
        conversationId: conversationId,
      );
    }).toList();

    final jsonList = messageModels.map((m) => m.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(key, jsonString);

    // Optionally also update cached conversation's message list
    for (var message in messageModels) {
      await _updateConversationWithMessage(message);
    }
  }

  Future<void> _updateConversationWithMessage(MessageModel message) async {
    if (message.conversationId == null) return;

    final jsonString = sharedPreferences.getString(CACHED_CONVERSATIONS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<ConversationModel> conversations = jsonList
          .map((jsonMap) => ConversationModel.fromJson(jsonMap))
          .toList();

      // Find the conversation to update
      final conversationIndex = conversations.indexWhere(
        (c) => c.id == message.conversationId,
      );

      if (conversationIndex != -1) {
        // Add message to conversation
        final updatedConversation = conversations[conversationIndex].copyWith(
          messages: [...conversations[conversationIndex].messages, message],
        );

        // Update conversation in list
        conversations[conversationIndex] = updatedConversation;

        // Save back to shared preferences
        final List<Map<String, dynamic>> updatedJsonList =
            conversations.map((conversation) => conversation.toJson()).toList();
        await sharedPreferences.setString(
          CACHED_CONVERSATIONS_KEY,
          json.encode(updatedJsonList),
        );
      }
    }
  }
}
