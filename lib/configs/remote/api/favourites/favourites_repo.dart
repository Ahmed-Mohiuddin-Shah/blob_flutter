import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';
import 'package:dio/dio.dart';

abstract final class FavouritesRepo {
  static final _api = ApiManager.instance.apiConfigs;

  static Future<({CursorPage<Map<String, dynamic>>? data, ApiError? error})>
      list({String? cursor}) async {
    try {
      final res = await _api.dioAdapter.get(
        '/api/favourites',
        queryParameters: {if (cursor != null) 'cursor': cursor},
      );
      return (
        data: ApiParse.cursorPage(
          res.data,
          (m) => m,
        ),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({ApiError? error})> put({
    required String subjectType,
    required String subjectId,
  }) async {
    try {
      await _api.dioAdapter.put(
        '/api/favourites',
        data: {'subjectType': subjectType, 'subjectId': subjectId},
      );
      return (error: null);
    } on DioException catch (e) {
      return (error: _err(e));
    } catch (e) {
      return (error: ApiError(message: e.toString()));
    }
  }

  static Future<({ApiError? error})> delete({
    required String subjectType,
    required String subjectId,
  }) async {
    try {
      await _api.dioAdapter.delete(
        '/api/favourites',
        data: {'subjectType': subjectType, 'subjectId': subjectId},
      );
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
