import 'package:blob_flutter/configs/app/global/env_configs.dart';
import 'package:blob_flutter/configs/remote/api/token_refresher.dart';
import 'package:blob_flutter/configs/utils/secure_storage.dart';
import 'package:dio/dio.dart';

class ApiConfigs {
  ApiConfigs({this.public = false}) {
    dioAdapter = Dio(
      BaseOptions(
        baseUrl: EnvConfigs.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );
    dioAdapter.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!public) {
            final token = await secureStorage.accessToken;
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (!public &&
              error.response?.statusCode == 401 &&
              error.requestOptions.extra['retried'] != true) {
            final ok = await TokenRefresher.refresh();
            if (ok) {
              final req = error.requestOptions;
              req.extra['retried'] = true;
              final token = await secureStorage.accessToken;
              if (token != null) {
                req.headers['Authorization'] = 'Bearer $token';
              }
              try {
                final response = await dioAdapter.fetch(req);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  final bool public;
  late final Dio dioAdapter;
}

class ApiManager {
  ApiManager._();
  static final ApiManager instance = ApiManager._();
  final ApiConfigs apiConfigs = ApiConfigs();
}

class ApiManagerPublic {
  ApiManagerPublic._();
  static final ApiManagerPublic instance = ApiManagerPublic._();
  final ApiConfigs apiConfigs = ApiConfigs(public: true);
}
