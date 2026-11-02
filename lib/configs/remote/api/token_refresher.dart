import 'package:blob_flutter/configs/utils/app_logger.dart';
import 'package:blob_flutter/configs/utils/secure_storage.dart';

/// Single-flight refresh placeholder — wire Zitadel refresh token grant next.
abstract final class TokenRefresher {
  static Future<bool>? _inFlight;

  static Future<bool> refresh() {
    return _inFlight ??= _doRefresh().whenComplete(() => _inFlight = null);
  }

  static Future<bool> _doRefresh() async {
    final refresh = await secureStorage.refreshToken;
    if (refresh == null || refresh.isEmpty) {
      appLog.warning('Token refresh skipped: no refresh token');
      await secureStorage.clearTokens();
      return false;
    }
    // ponytail: refresh via Zitadel token endpoint when issuer/client are set.
    appLog.info('Token refresh not yet implemented against Zitadel');
    return false;
  }
}
