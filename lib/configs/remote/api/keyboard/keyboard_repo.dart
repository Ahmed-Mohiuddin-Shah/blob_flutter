import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:dio/dio.dart';

abstract final class KeyboardRepo {
  static final _api = ApiManager.instance.apiConfigs;

  static Future<({CursorPage<StickerModel>? data, ApiError? error})> stickers({
    String? cursor,
    String? q,
  }) async {
    try {
      final res = await _api.dioAdapter.get(
        '/api/keyboard/stickers',
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
          if (q != null && q.isNotEmpty) 'q': q,
        },
      );
      final page = ApiParse.cursorPage(res.data, (m) {
        return StickerModel(
          id: '${m['id']}',
          title: m['title'] as String?,
          slug: m['slug'] as String?,
          chatUrl: ApiParse.absoluteUrl(
            m['chatUrl'] as String? ?? m['chat'] as String?,
          ),
          thumbnailUrl: ApiParse.absoluteUrl(
            m['thumbUrl'] as String? ?? m['thumbnailUrl'] as String?,
          ),
        );
      });
      return (data: page, error: null);
    } on DioException catch (e) {
      return (
        data: null,
        error: ApiError(
          message: e.message ?? 'keyboard failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }
}
