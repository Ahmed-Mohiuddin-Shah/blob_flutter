import 'dart:io';

import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/data/models/app_version/app_version_check_model.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract final class AppVersionRepo {
  static final ApiConfigs _api = ApiManagerPublic.instance.apiConfigs;

  static Future<({AppVersionCheckModel? data, ApiError? error})> check() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = '${info.version}+${info.buildNumber}';
      final platform = Platform.isIOS ? 'ios' : 'android';
      final Response response = await _api.dioAdapter.get(
        '/api/app-version/check',
        queryParameters: {'platform': platform, 'version': version},
      );
      final map = Map<String, dynamic>.from(response.data as Map);
      return (data: AppVersionCheckModel.fromJson(map), error: null);
    } on DioException catch (e) {
      return (
        data: null,
        error: ApiError(
          message: e.message ?? 'version check failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }
}
