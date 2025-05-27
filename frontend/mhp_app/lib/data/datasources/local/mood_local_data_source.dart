import 'package:mental_health_partner/core/storage/local_storage.dart';
import '../../models/mood_model.dart';

abstract class MoodLocalDataSource {
  Future<void> cacheMood(MoodModel mood);
  Future<void> cacheMoodHistory(List<MoodModel> moods);
  Future<List<MoodModel>> getCachedMoodHistory();
}

class MoodLocalDataSourceImpl implements MoodLocalDataSource {
  final LocalStorage localStorage;
  static const String CACHE_KEY = 'mood_history';

  MoodLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> cacheMood(MoodModel mood) async {
    final cached = localStorage.getObject(CACHE_KEY) ?? {'entries': []};
    final entries = (cached['entries'] as List).cast<Map<String, dynamic>>();
    entries.add(mood.toJson());
    await localStorage.setObject(CACHE_KEY, {'entries': entries});
  }

  @override
  Future<List<MoodModel>> getCachedMoodHistory() async {
    final cached = localStorage.getObject(CACHE_KEY);
    if (cached != null) {
      return (cached['entries'] as List)
          .map((json) => MoodModel.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheMoodHistory(List<MoodModel> moods) async {
    final cached = localStorage.getObject(CACHE_KEY) ?? {'entries': []};
    cached['entries'] = moods.map((mood) => mood.toJson()).toList();
    await localStorage.setObject(CACHE_KEY, cached);
  }
}
