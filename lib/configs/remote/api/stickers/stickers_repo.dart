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

  /// Live API only accepts numeric ids (`BigInt`). Slug → resolve via list `q`.
  static Future<({StickerModel? data, ApiError? error})> getByIdOrSlug(
    String idOrSlug,
  ) async {
    final key = idOrSlug.trim();
    if (key.isEmpty) {
      return (data: null, error: ApiError(message: 'Missing sticker id'));
    }

    if (ApiParse.isNumericId(key)) {
      return _getById(key);
    }

    // Slug detail 500s server-side — find id from list search.
    final listed = await list(q: key);
    final items = listed.data?.items ?? const <StickerModel>[];
    StickerModel? match;
    for (final s in items) {
      if (s.slug == key || s.id == key) {
        match = s;
        break;
      }
    }
    match ??= items.isNotEmpty ? items.first : null;
    if (match == null) {
      return (
        data: null,
        error: listed.error ?? ApiError(message: 'Sticker not found'),
      );
    }
    return _getById(match.id);
  }

  static Future<({StickerModel? data, ApiError? error})> _getById(
    String id,
  ) async {
    try {
      final res = await _public.dioAdapter.get('/api/stickers/$id');
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
      // Anonymous guests get 403 — soft-fail to empty.
      if (e.response?.statusCode == 403) {
        return (
          data: const CursorPage<StickerModel>(items: []),
          error: null,
        );
      }
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
      final body = res.data;
      if (body is Map && body['ok'] == true) {
        return _getById(id);
      }
      return (
        data: _withAbsoluteUrls(
          StickerModel.fromJson(Map<String, dynamic>.from(body as Map)),
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
