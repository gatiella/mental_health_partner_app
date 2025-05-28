import 'dart:convert';

import 'package:mental_health_partner/data/models/analytics_model.dart'
    as model;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_partner/data/models/analytics_model.dart';

abstract class AnalyticsLocalDataSource {
  Future<void> cacheMoodAnalytics(MoodAnalytics data);
  Future<MoodAnalytics?> getCachedMoodAnalytics();

  Future<void> cacheUserActivity(UserActivity data);
  Future<UserActivity?> getCachedUserActivity();
}

class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  final SharedPreferences prefs;

  AnalyticsLocalDataSourceImpl({required this.prefs});

  static const String moodAnalyticsKey = 'CACHED_MOOD_ANALYTICS';
  static const String userActivityKey = 'CACHED_USER_ACTIVITY';

  @override
  Future<void> cacheMoodAnalytics(MoodAnalytics data) async {
    final jsonString = json.encode(data.toJson());
    await prefs.setString(moodAnalyticsKey, jsonString);
  }

  @override
  Future<MoodAnalytics?> getCachedMoodAnalytics() async {
    final jsonString = prefs.getString(moodAnalyticsKey);
    if (jsonString != null) {
      return MoodAnalytics.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUserActivity(model.UserActivity data) async {
    final jsonString = json.encode(data.toJson());
    await prefs.setString(userActivityKey, jsonString);
  }

  @override
  Future<model.UserActivity?> getCachedUserActivity() async {
    final jsonString = prefs.getString(userActivityKey);
    if (jsonString != null) {
      return model.UserActivity.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
