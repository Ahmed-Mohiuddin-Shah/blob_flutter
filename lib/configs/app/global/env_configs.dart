import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class EnvConfigs {
  const EnvConfigs._();

  static Future<void> init() => dotenv.load(fileName: '.env');

  static String get baseUrl => get('BASE_URL');
  static String get zitadelIssuer => get('ZITADEL_ISSUER');
  static String get zitadelClientId => get('ZITADEL_CLIENT_ID');
  static String get zitadelRedirectUrl => get('ZITADEL_REDIRECT_URL');
  static String get zitadelApiClientId => get('ZITADEL_API_CLIENT_ID');

  static bool get measureEnabled {
    final raw = get('MEASURE_ENABLED', fallback: 'false').toLowerCase();
    return raw == 'true' || raw == '1';
  }

  /// Self-hosted Measure API / ingest base (native SDKs also read platform keys).
  static String get measureApiUrl => get('MEASURE_API_URL', fallback: '');

  static String get(String name, {String? fallback}) {
    final flavor = appFlavor;
    if (flavor == null || flavor.isEmpty) {
      throw StateError('App flavor is not set. Run with --flavor dev|prod.');
    }
    final key = '${flavor.toUpperCase()}_$name';
    final value = dotenv.maybeGet(key)?.trim();
    if (value != null && value.isNotEmpty) return value;
    if (fallback != null) return fallback;
    return '';
  }
}
