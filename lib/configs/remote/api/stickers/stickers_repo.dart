import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/common/cursor_page.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:dio/dio.dart';

abstract final class StickersRepo {
  static final _public = ApiManagerPublic.instance.apiConfigs;
  static final _auth = ApiManager.instance.apiConfigs;

  static StickerModel _withAbsoluteUrls(StickerModel s) => StickerModel(
        id: s.id,
        title: s.title,
        slug: s.slug,
        description: s.description,
        status: s.status,
        chatUrl: ApiParse.absoluteUrl(s.chatUrl),
        thumbnailUrl: ApiParse.absoluteUrl(s.thumbnailUrl),
        imageUrl: ApiParse.absoluteUrl(s.imageUrl),
        username: s.username,
      );

  static Future<({CursorPage<StickerModel>? data, ApiError? error})> list({
    String? q,
    String? cursor,
    bool mine = false,
    String? status,
  }) async {
    try {
      final api = mine ? _auth : _public;
      final res = await api.dioAdapter.get(
        '/api/stickers',
        queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
          if (cursor != null) 'cursor': cursor,
          if (mine) 'mine': '1',
          if (status != null) 'status': status,
        },
      );
      final page = ApiParse.cursorPage(res.data, StickerModel.fromJson);
      return (
        data: CursorPage(
          items: page.items.map(_withAbsoluteUrls).toList(),
          nextCursor: page.nextCursor,
        ),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({StickerModel? data, ApiError? error})> getByIdOrSlug(
    String idOrSlug,
  ) async {
    try {
      // Slug detail currently 500s on server — try as given, then numeric id.
      final res = await _public.dioAdapter.get('/api/stickers/$idOrSlug');
      final map = Map<String, dynamic>.from(res.data as Map);
      return (data: _withAbsoluteUrls(StickerModel.fromJson(map)), error: null);
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({CursorPage<StickerModel>? data, ApiError? error})> similar(
    String id,
  ) async {
    try {
      final res = await _public.dioAdapter.get('/api/stickers/$id/similar');
      final page = ApiParse.cursorPage(res.data, StickerModel.fromJson);
      return (
        data: CursorPage(
          items: page.items.map(_withAbsoluteUrls).toList(),
          nextCursor: page.nextCursor,
        ),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({StickerModel? data, ApiError? error})> patchMetadata(
    String id, {
    String? title,
    String? description,
  }) async {
    try {
      final res = await _auth.dioAdapter.patch(
        '/api/stickers/$id',
        data: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
        },
      );
      return (
        data: _withAbsoluteUrls(
          StickerModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        ),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({ApiError? error})> createAttributionClaim(String id) async {
    try {
      await _auth.dioAdapter.post('/api/stickers/$id/attribution-claims');
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
