import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/collections/collection_model.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';
import 'package:dio/dio.dart';

abstract final class CollectionsRepo {
  static final _public = ApiManagerPublic.instance.apiConfigs;
  static final _auth = ApiManager.instance.apiConfigs;

  static Future<({CursorPage<CollectionModel>? data, ApiError? error})> list({
    String? cursor,
  }) async {
    try {
      final res = await _public.dioAdapter.get(
        '/api/collections',
        queryParameters: {if (cursor != null) 'cursor': cursor},
      );
      return (data: ApiParse.cursorPage(res.data, CollectionModel.fromJson), error: null);
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({CollectionModel? data, ApiError? error})> get(String slug) async {
    try {
      final res = await _public.dioAdapter.get('/api/collections/$slug');
      return (
        data: CollectionModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({CollectionModel? data, ApiError? error})> create({
    required String title,
  }) async {
    try {
      final res = await _auth.dioAdapter.post(
        '/api/collections',
        data: {'title': title},
      );
      return (
        data: CollectionModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({ApiError? error})> addSticker(
    String slug,
    String stickerId,
  ) async {
    try {
      await _auth.dioAdapter.post(
        '/api/collections/$slug/stickers',
        data: {'stickerId': stickerId},
      );
      return (error: null);
    } on DioException catch (e) {
      return (error: _err(e));
    } catch (e) {
      return (error: ApiError(message: e.toString()));
    }
  }

  static Future<({ApiError? error})> removeSticker(
    String slug,
    String stickerId,
  ) async {
    try {
      await _auth.dioAdapter.delete('/api/collections/$slug/stickers/$stickerId');
      return (error: null);
    } on DioException catch (e) {
      return (error: _err(e));
    } catch (e) {
      return (error: ApiError(message: e.toString()));
    }
  }

  static Future<({ApiError? error})> toPack(String slug) async {
    try {
      await _auth.dioAdapter.post('/api/collections/$slug/pack');
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
