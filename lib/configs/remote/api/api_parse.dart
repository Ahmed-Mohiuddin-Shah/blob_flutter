import 'package:blob_flutter/configs/app/global/env_configs.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';

abstract final class ApiParse {
  const ApiParse._();

  static String asId(dynamic value) => '${value ?? ''}';

  static bool isNumericId(String value) =>
      RegExp(r'^\d+$').hasMatch(value.trim());

  static String? pickString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final v = map[key];
      if (v == null) continue;
      if (v is String && v.isNotEmpty) return v;
      if (v is! String) {
        final s = '$v';
        if (s.isNotEmpty && s != 'null') return s;
      }
    }
    return null;
  }

  static String? absoluteUrl(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.isEmpty) return null;
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return pathOrUrl;
    }
    final path = pathOrUrl.startsWith('/') ? pathOrUrl : '/$pathOrUrl';
    try {
      final base = EnvConfigs.baseUrl.replaceAll(RegExp(r'/$'), '');
      if (base.isEmpty) return path;
      return '$base$path';
    } catch (_) {
      // Tests / no flavor — keep relative proxy path.
      return path;
    }
  }

  /// Cursor lists use `items`; Meili search uses `hits`.
  static CursorPage<T> cursorPage<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final map = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};
    final raw = map['items'] ?? map['hits'] ?? map['data'] ?? const [];
    final list = <T>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          list.add(fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
    return CursorPage(items: list, nextCursor: map['nextCursor'] as String?);
  }
}
