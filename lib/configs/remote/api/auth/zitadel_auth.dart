import 'package:blob_flutter/configs/app/global/env_configs.dart';
import 'package:blob_flutter/configs/utils/app_logger.dart';
import 'package:blob_flutter/configs/utils/secure_storage.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

abstract final class ZitadelAuth {
  static const FlutterAppAuth _appAuth = FlutterAppAuth();

  static Future<bool> signIn() async {
    final clientId = EnvConfigs.zitadelClientId;
    final issuer = EnvConfigs.zitadelIssuer;
    final redirect = EnvConfigs.zitadelRedirectUrl;
    final audience = EnvConfigs.zitadelApiClientId;
    if (clientId.isEmpty || issuer.isEmpty || redirect.isEmpty) {
      appLog.warning('Zitadel env incomplete — cannot sign in');
      return false;
    }
    // Issuer must be origin only; discovery is derived.
    final issuerUri = Uri.parse(issuer);
    final cleanIssuer =
        '${issuerUri.scheme}://${issuerUri.host}${issuerUri.hasPort ? ':${issuerUri.port}' : ''}';
    final discoveryUrl = '$cleanIssuer/.well-known/openid-configuration';

    try {
      appLog.info('Zitadel sign-in redirect=$redirect discovery=$discoveryUrl');
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirect,
          discoveryUrl: discoveryUrl,
          scopes: const ['openid', 'profile', 'email', 'offline_access'],
          additionalParameters: {
            if (audience.isNotEmpty) 'audience': audience,
          },
        ),
      );
      final access = result.accessToken;
      if (access == null || access.isEmpty) return false;
      await secureStorage.saveTokens(
        accessToken: access,
        refreshToken: result.refreshToken,
      );
      return true;
    } on FlutterAppAuthUserCancelledException {
      appLog.info('Zitadel sign-in cancelled');
      return false;
    } catch (e, st) {
      appLog.severe('Zitadel sign-in failed: $e', e, st);
      return false;
    }
  }

  static Future<void> signOut() => secureStorage.clearTokens();

  static Future<bool> hasSession() async {
    final token = await secureStorage.accessToken;
    return token != null && token.isNotEmpty;
  }
}
