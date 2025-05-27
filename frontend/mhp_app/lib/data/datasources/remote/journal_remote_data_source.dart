// data/datasources/journal_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:mental_health_partner/domain/entities/journal.dart';
import '../../../../config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';

abstract class JournalRemoteDataSource {
  Future<Journal> createEntry(String title, String content, String mood);
  Future<List<Journal>> getEntries();
  Future<void> deleteEntry(String entryId);
}

class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  final ApiClient client;

  JournalRemoteDataSourceImpl({required this.client});

  @override
  Future<Journal> createEntry(String title, String content, String mood) async {
    try {
      int? moodScore;
      String? moodNote;
      try {
        moodScore = int.parse(mood);
      } catch (_) {
        moodNote = mood;
      }

      final response = await client.post(
        ApiConfig.journals,
        data: {
          'title': title,
          'content': content,
          'mood_score': moodScore,
          'mood_note': moodNote,
        },
      );

      return Journal.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to create entry');
    }
  }

  @override
  Future<List<Journal>> getEntries() async {
    try {
      final response = await client.get(ApiConfig.journals);

      if (response.data is List) {
        return _parseJournalList(response.data);
      } else if (response.data is Map) {
        if (response.data.containsKey('results')) {
          return _parseJournalList(response.data['results']);
        } else {
          try {
            return [Journal.fromJson(response.data)];
          } catch (e) {
            for (var key in response.data.keys) {
              if (response.data[key] is List) {
                return _parseJournalList(response.data[key]);
              }
            }
          }
        }
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to fetch entries');
    } catch (e) {
      print('Error parsing journal entries: $e');
      throw ServerException(message: 'Failed to parse journal entries: $e');
    }
  }

  List<Journal> _parseJournalList(List<dynamic> jsonList) {
    return jsonList.map((json) => Journal.fromJson(json)).toList();
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    try {
      await client.delete(ApiConfig.journalDetail(entryId));
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete entry');
    }
  }
}
