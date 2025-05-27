// data/datasources/journal_local_data_source.dart
import 'package:mental_health_partner/core/storage/local_storage.dart';
import 'package:mental_health_partner/domain/entities/journal.dart';

abstract class JournalLocalDataSource {
  Future<void> cacheJournalEntries(List<Journal> entries);
  Future<List<Journal>> getCachedJournalEntries();
  Future<void> deleteCachedEntry(String entryId);
  Future<void> clearCache();
}

class JournalLocalDataSourceImpl implements JournalLocalDataSource {
  final LocalStorage localStorage;
  static const String CACHE_KEY = 'journal_entries';

  JournalLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> cacheJournalEntries(List<Journal> entries) async {
    final entriesJson = entries.map((entry) => entry.toJson()).toList();
    await localStorage.setObject(CACHE_KEY, {'entries': entriesJson});
  }

  @override
  Future<List<Journal>> getCachedJournalEntries() async {
    final cachedData = localStorage.getObject(CACHE_KEY);
    if (cachedData != null) {
      return (cachedData['entries'] as List)
          .map((json) => Journal.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<void> deleteCachedEntry(String entryId) async {
    final entries = await getCachedJournalEntries();
    entries.removeWhere((entry) => entry.id == entryId);
    await cacheJournalEntries(entries);
  }

  @override
  Future<void> clearCache() async {
    await localStorage.remove(CACHE_KEY);
  }
}
