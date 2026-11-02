import 'package:blob_flutter/configs/app/global/env_configs.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';

abstract final class ApiParse {
  const ApiParse._();

  static String? absoluteUrl(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.isEmpty) return null;
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return pathOrUrl;
    }
    final base = EnvConfigs.baseUrl.replaceAll(RegExp(r'/$'), '');
    final path = pathOrUrl.startsWith('/') ? pathOrUrl : '/$pathOrUrl';
    return '$base$path';
  }

  static CursorPage<T> cursorPage<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final map = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};
    final raw = map['items'] ?? map['data'] ?? const [];
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
