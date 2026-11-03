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
        queryParameters: {'cursor': ?cursor},
      );
      return (
        data: ApiParse.cursorPage(res.data, BlobberModel.fromJson),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  /// Live API accepts numeric ids only. Slug → resolve from directory list.
  static Future<({BlobberModel? data, ApiError? error})> get(
    String idOrSlug,
  ) async {
    final key = idOrSlug.trim();
    if (key.isEmpty) {
      return (data: null, error: ApiError(message: 'Missing blobber id'));
    }
    if (ApiParse.isNumericId(key)) {
      return _getById(key);
    }
    final listed = await list();
    final items = listed.data?.items ?? const <BlobberModel>[];
    BlobberModel? match;
    for (final b in items) {
      if (b.slug == key || b.username == key || b.displayName == key) {
        match = b;
        break;
      }
    }
    if (match == null) {
      return (
        data: null,
        error: listed.error ?? ApiError(message: 'Blobber not found'),
      );
    }
    return _getById(match.id);
  }

  static Future<({BlobberModel? data, ApiError? error})> _getById(
    String id,
  ) async {
    try {
      final res = await _public.dioAdapter.get('/api/blobbers/$id');
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
          'description': ?bio,
          'displayName': ?displayName,
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
      // Live route: /api/blobber-association-requests
      await _auth.dioAdapter.post('/api/blobber-association-requests');
      return (error: null);
    } on DioException catch (e) {
      return (error: _err(e));
    } catch (e) {
      return (error: ApiError(message: e.toString()));
    }
  }

  static ApiError _err(DioException e) {
    final data = e.response?.data;
    String? apiMsg;
    if (data is Map && data['error'] != null) apiMsg = '${data['error']}';
    return ApiError(
      message: apiMsg ?? e.message ?? 'request failed',
      statusCode: e.response?.statusCode,
    );
  }
}
