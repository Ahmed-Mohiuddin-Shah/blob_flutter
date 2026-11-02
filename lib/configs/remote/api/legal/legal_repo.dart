import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/data/models/legal/legal_model.dart';
import 'package:dio/dio.dart';

abstract final class LegalRepo {
  static final _api = ApiManagerPublic.instance.apiConfigs;

  static Future<({LegalDocument? data, ApiError? error})> get(String slug) async {
    try {
      final res = await _api.dioAdapter.get('/api/legal/$slug');
      return (
        data: LegalDocument.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (
        data: null,
        error: ApiError(
          message: e.message ?? 'legal failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }
}
