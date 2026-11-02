import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:dio/dio.dart';

abstract final class SearchRepo {
  static final _api = ApiManagerPublic.instance.apiConfigs;

  static Future<({CursorPage<StickerModel>? data, ApiError? error})> search({
    required String q,
    String? cursor,
  }) async {
    try {
      final res = await _api.dioAdapter.get(
        '/api/search',
        queryParameters: {'q': q, if (cursor != null) 'cursor': cursor},
      );
      // Search may return mixed types; prefer sticker-shaped items.
      return (
        data: ApiParse.cursorPage(res.data, StickerModel.fromJson),
        error: null,
      );
    } on DioException catch (e) {
      return (
        data: null,
        error: ApiError(
          message: e.message ?? 'search failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }
}
