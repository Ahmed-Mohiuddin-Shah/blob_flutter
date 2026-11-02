import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _access = 'accessToken';
  static const _refresh = 'refreshToken';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<String?> get accessToken => _storage.read(key: _access);
  Future<String?> get refreshToken => _storage.read(key: _refresh);

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _access, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refresh, value: refreshToken);
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _access);
    await _storage.delete(key: _refresh);
  }
}

final SecureStorage secureStorage = SecureStorage();
