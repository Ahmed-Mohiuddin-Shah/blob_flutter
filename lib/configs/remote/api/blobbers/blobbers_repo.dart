import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/blobbers/blobber_model.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';
import 'package:dio/dio.dart';

abstract final class BlobbersRepo {
  static final _public = ApiManagerPublic.instance.apiConfigs;
  static final _auth = ApiManager.instance.apiConfigs;

  static Future<({CursorPage<BlobberModel>? data, ApiError? error})> list({
    String? cursor,
  }) async {
    try {
      final res = await _public.dioAdapter.get(
        '/api/blobbers',
        queryParameters: {if (cursor != null) 'cursor': cursor},
      );
      return (data: ApiParse.cursorPage(res.data, BlobberModel.fromJson), error: null);
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({BlobberModel? data, ApiError? error})> get(String idOrSlug) async {
    try {
      final res = await _public.dioAdapter.get('/api/blobbers/$idOrSlug');
      return (
        data: BlobberModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({BlobberModel? data, ApiError? error})> me() async {
    try {
      final res = await _auth.dioAdapter.get('/api/blobbers/me');
      return (
        data: BlobberModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({BlobberModel? data, ApiError? error})> patchMe({
    String? bio,
    String? displayName,
  }) async {
    try {
      final res = await _auth.dioAdapter.patch(
        '/api/blobbers/me',
        data: {
          if (bio != null) 'bio': bio,
          if (displayName != null) 'displayName': displayName,
        },
      );
      return (
        data: BlobberModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({ApiError? error})> requestAssociation() async {
    try {
      await _auth.dioAdapter.post('/api/blobbers/associations');
      return (error: null);
    } on DioException catch (e) {
      return (error: _err(e));
    } catch (e) {
      return (error: ApiError(message: e.toString()));
    }
  }

  static ApiError _err(DioException e) => ApiError(
        message: e.message ?? 'request failed',
        statusCode: e.response?.statusCode,
      );
}
