import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:dio/dio.dart';

abstract final class SearchRepo {
  static final _api = ApiManagerPublic.instance.apiConfigs;

  /// Guest-safe keywords mode. Live default is hybrid → 403 for anonymous.
  static Future<({CursorPage<StickerModel>? data, ApiError? error})> search({
    required String q,
    String? cursor,
  }) async {
    try {
      final res = await _api.dioAdapter.get(
        '/api/search',
        queryParameters: {
          'q': q,
          'mode': 'keywords',
          'scope': 'stickers',
          if (cursor != null) 'cursor': cursor,
        },
      );
      final page = ApiParse.cursorPage(res.data, StickerModel.fromJson);
      return (
        data: CursorPage(
          items: page.items
              .map(
                (s) => StickerModel(
                  id: s.id,
                  title: s.title,
                  slug: s.slug,
                  description: s.description,
                  status: s.status,
                  chatUrl: ApiParse.absoluteUrl(s.chatUrl),
                  thumbnailUrl: ApiParse.absoluteUrl(s.thumbnailUrl),
                  imageUrl: ApiParse.absoluteUrl(s.imageUrl),
                  username: s.username,
                ),
              )
              .toList(),
          nextCursor: page.nextCursor,
        ),
        error: null,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      String? apiMsg;
      if (data is Map && data['error'] != null) apiMsg = '${data['error']}';
      return (
        data: null,
        error: ApiError(
          message: apiMsg ?? e.message ?? 'search failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }
}
