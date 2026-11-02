import 'dart:convert';
import 'dart:typed_data';

import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:dio/dio.dart';

abstract final class CompositionRepo {
  static final _auth = ApiManager.instance.apiConfigs;
  static final _public = ApiManagerPublic.instance.apiConfigs;

  /// Create sticker from composition (upload flow).
  static Future<({StickerModel? data, ApiError? error})> create({
    required Map<String, dynamic> document,
    required Uint8List chat,
    required Uint8List thumbnail,
    required Uint8List full,
    Uint8List? mask,
    String title = 'Untitled',
  }) async {
    try {
      final form = FormData.fromMap({
        'title': title,
        'visibility': 'public',
        'document': jsonEncode(document),
        'chat': MultipartFile.fromBytes(chat, filename: 'chat.png'),
        'thumbnail': MultipartFile.fromBytes(
          thumbnail,
          filename: 'thumbnail.png',
        ),
        'full': MultipartFile.fromBytes(full, filename: 'full.png'),
        if (mask != null)
          'mask': MultipartFile.fromBytes(mask, filename: 'mask.png'),
      });

      final res = await _auth.dioAdapter.post('/api/stickers', data: form);
      return (
        data: StickerModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({StickerModel? data, ApiError? error})> saveComposition(
    String id, {
    required Map<String, dynamic> document,
    required Uint8List chat,
    required Uint8List thumbnail,
    required Uint8List full,
    Uint8List? mask,
  }) async {
    try {
      final form = FormData.fromMap({
        'document': jsonEncode(document),
        'chat': MultipartFile.fromBytes(chat, filename: 'chat.png'),
        'thumbnail': MultipartFile.fromBytes(
          thumbnail,
          filename: 'thumbnail.png',
        ),
        'full': MultipartFile.fromBytes(full, filename: 'full.png'),
        if (mask != null)
          'mask': MultipartFile.fromBytes(mask, filename: 'mask.png'),
      });

      final res = await _auth.dioAdapter.post(
        '/api/stickers/$id/composition',
        data: form,
      );
      return (
        data: StickerModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  static Future<({StickerModel? data, ApiError? error})> remix(
    String id,
  ) async {
    try {
      final res = await _auth.dioAdapter.post('/api/stickers/$id/remix');
      return (
        data: StickerModel.fromJson(Map<String, dynamic>.from(res.data as Map)),
        error: null,
      );
    } on DioException catch (e) {
      return (data: null, error: _err(e));
    } catch (e) {
      return (data: null, error: ApiError(message: e.toString()));
    }
  }

  /// Poll until media ready or failed / timeout.
  static Future<({StickerModel? data, ApiError? error})> pollUntilReady(
    String id, {
    int maxAttempts = 40,
    Duration interval = const Duration(seconds: 2),
  }) async {
    for (var i = 0; i < maxAttempts; i++) {
      try {
        final res = await _public.dioAdapter.get('/api/stickers/$id');
        final s = StickerModel.fromJson(
          Map<String, dynamic>.from(res.data as Map),
        );
        final status = (s.status ?? '').toLowerCase();
        if (status == 'approved' ||
            status == 'ready' ||
            status == 'published') {
          return (data: s, error: null);
        }
        if (status == 'failed' || status == 'rejected') {
          return (data: s, error: ApiError(message: 'Processing $status'));
        }
      } on DioException catch (e) {
        if (i == maxAttempts - 1) return (data: null, error: _err(e));
      }
      await Future<void>.delayed(interval);
    }
    return (data: null, error: ApiError(message: 'Processing timeout'));
  }

  static ApiError _err(DioException e) => ApiError(
    message: e.message ?? 'request failed',
    statusCode: e.response?.statusCode,
  );
}
