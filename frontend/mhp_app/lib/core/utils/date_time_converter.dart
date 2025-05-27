import 'package:json_annotation/json_annotation.dart';

class SafeDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const SafeDateTimeConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;
    try {
      return DateTime.parse(json);
    } catch (_) {
      return null;
    }
  }

  @override
  String? toJson(DateTime? object) => object?.toIso8601String();
}
