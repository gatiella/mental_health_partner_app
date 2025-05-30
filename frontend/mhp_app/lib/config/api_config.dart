import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'environment.dart';

class ApiConfig {
  // Base configuration
  static String get baseUrl => Environment.apiBaseUrl;
  static int get timeout => Environment.apiTimeout;

  // App constants
  static const String appName = "Mental Health Partner";
  static const String supportEmail = "support@mentalhealthpartner.com";
  static const int dailyReminderHour = 20; // 8 PM
  static const int maxJournalEntries = 1000;
  static const int maxConversationHistory = 100;

// Authentication endpoints
  static String get login => '/api/users/login/';
  static String get register => '/api/users/register/';
  static String get refreshToken => '/api/users/token/refresh/';
  static String get userProfile => '/api/users/profile/';
  static const String verifyEmail = '/api/users/verify-email';
// Conversation endpoints
  static String get conversations => '/api/conversation/';
  static String sendMessage(String conversationId) =>
      '/api/conversation/$conversationId/message/';
  static String getConversation(String conversationId) =>
      '/api/conversation/$conversationId/';

// Journal endpoints
  static String get journals => '/api/journal/';
  static String journalDetail(String journalId) => '/api/journal/$journalId/';
// Mood endpoints
  static String get moods => '/api/mood/';
  static String moodDetail(String moodId) => '/api/mood/$moodId/';

// Analytics endpoints
  static String get moodAnalytics => '/api/analytics/mood/';
  static String get userActivity => '/api/analytics/activity/';
  static String get communityEngagement =>
      '/api/analytics/community/engagement/';
  static String get discussionGroupMetrics =>
      '/api/analytics/community/discussion-groups/';
  static String get challengeCompletionRates =>
      '/api/analytics/community/challenges/';
  static String get forumActivity => '/api/analytics/community/forum/';
  static String get successStoryImpact =>
      '/api/analytics/community/success-stories/';

  // Gamification endpoints (from ApiEndpoints)
  static String get userPoints => '/api/gamification/points/';
  static String get quests => '/api/gamification/quests/?no_pagination=true';
  static String get recommendedQuests =>
      '/api/gamification/quests/recommended/?no_pagination=true';

  // Community endpoints
  static String get discussionGroups => '/api/community/discussion-groups/';
  static String joinDiscussionGroup(String groupId) =>
      '/api/community/discussion-groups/$groupId/join/';
  static String leaveDiscussionGroup(String groupId) =>
      '/api/community/discussion-groups/$groupId/leave/';

  static String get forumThreads => '/api/community/forum-threads/';
  static String forumThreadDetail(String threadId) =>
      '/api/community/forum-threads/$threadId/';

  static String get forumPosts => '/api/community/forum-posts/';
  static String get toggleEncouragement =>
      '/api/community/encouragements/toggle/';

  static String get challenges => '/api/community/challenges/';
  static String joinChallenge(String challengeId) =>
      '/api/community/challenges/$challengeId/join/';
  static String completeChallenge(String challengeId) =>
      '/api/community/challenges/$challengeId/complete/';

  static String get successStories => '/api/community/success-stories/';
  static String get toggleStoryEncouragement =>
      '/api/community/story-encouragements/toggle/';

  // Headers utility (moved from ApiEndpoints)
  static Map<String, String> getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Full URL construction helper
  static String fullUrl(String endpoint) {
    // Ensure baseUrl doesn't end with slash when endpoint starts with slash
    if (baseUrl.endsWith('/') && endpoint.startsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1) + endpoint;
    }
    // Ensure there's a slash between baseUrl and endpoint
    else if (!baseUrl.endsWith('/') && !endpoint.startsWith('/')) {
      return '$baseUrl/$endpoint';
    }
    return baseUrl + endpoint;
  }

  // Token management helper (adapted from ApiEndpoints)
  static Future<String> getToken(SharedPreferences prefs) async {
    try {
      return prefs.getString('auth_token') ?? '';
    } catch (e) {
      debugPrint('Error getting token: $e');
      return '';
    }
  }
}
