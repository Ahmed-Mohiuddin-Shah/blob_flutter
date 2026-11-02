import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/data/models/me/me_model.dart';
import 'package:dio/dio.dart';

abstract final class MeRepo {
  static final ApiConfigs _api = ApiManager.instance.apiConfigs;

  static Future<({MeModel? data, ApiError? error})> getMe() async {
    try {
      final Response response = await _api.dioAdapter.get('/api/me');
      final map = Map<String, dynamic>.from(response.data as Map);
      return (data: MeModel.fromJson(map), error: null);
    } on DioException catch (e) {
      return (
        data: null,
        error: ApiError(
          message: e.message ?? 'me failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({MeModel? data, ApiError? error})> patchUsername(
    String username,
  ) async {
    try {
      final Response response = await _api.dioAdapter.patch(
        '/api/me',
        data: {'username': username},
      );
      final map = Map<String, dynamic>.from(response.data as Map);
      return (data: MeModel.fromJson(map), error: null);
    } on DioException catch (e) {
      return (
        data: null,
        error: ApiError(
          message: e.message ?? 'patch me failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }
}
