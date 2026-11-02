import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';
import 'package:blob_flutter/data/models/prints/print_models.dart';
import 'package:dio/dio.dart';

abstract final class PrintsRepo {
  static final _public = ApiManagerPublic.instance.apiConfigs;
  static final _auth = ApiManager.instance.apiConfigs;

  static Future<({CursorPage<SheetModel>? data, ApiError? error})> listSheets({
    String? cursor,
  }) async {
    try {
      final res = await _public.dioAdapter.get(
        '/api/sheets',
        queryParameters: {if (cursor != null) 'cursor': cursor},
      );
      return (
        data: ApiParse.cursorPage(res.data, SheetModel.fromJson),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({CursorPage<PackModel>? data, ApiError? error})> listPacks({
    String? cursor,
  }) async {
    try {
      final res = await _public.dioAdapter.get(
        '/api/packs',
        queryParameters: {if (cursor != null) 'cursor': cursor},
      );
      return (
        data: ApiParse.cursorPage(res.data, PackModel.fromJson),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({SheetModel? data, ApiError? error})> getSheet(
    String id,
  ) async {
    try {
      final res = await _public.dioAdapter.get('/api/sheets/$id');
      return (
        data: SheetModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({PackModel? data, ApiError? error})> getPack(String id) async {
    try {
      final res = await _public.dioAdapter.get('/api/packs/$id');
      return (
        data: PackModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({SheetModel? data, ApiError? error})> createSheet({
    required String title,
  }) async {
    try {
      final res = await _auth.dioAdapter.post(
        '/api/sheets',
        data: {'title': title},
      );
      return (
        data: SheetModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({PackModel? data, ApiError? error})> createPack({
    required String title,
  }) async {
    try {
      final res = await _auth.dioAdapter.post(
        '/api/packs',
        data: {'title': title},
      );
      return (
        data: PackModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static String mediaUrl(String kind, String id, {required bool sheet}) {
    final base = sheet
        ? '/api/sheets/$id/media/$kind'
        : '/api/packs/$id/media/$kind';
    return ApiParse.absoluteUrl(base);
  }

  static ApiError _err(DioException e) => ApiError(
    message: e.message ?? 'request failed',
    statusCode: e.response?.statusCode,
  );
}
