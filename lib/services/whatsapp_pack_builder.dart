import 'dart:io';

import 'package:blob_flutter/configs/app/global/env_configs.dart';
import 'package:blob_flutter/configs/remote/api/api_configs.dart';
import 'package:blob_flutter/data/local/app_database.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_stickers_exporter/whatsapp_stickers_exporter.dart';

/// Download → resize 512 WebP + tray ~96 → Drift stage → WhatsApp install.
/// v1 static only; animated deferred.
abstract final class WhatsappPackBuilder {
  static Future<void> buildAndSend({
    required AppDatabase db,
    required int packId,
    required List<String> stickerIds,
  }) async {
    final pack = await (db.select(db.whatsappPackDrafts)
          ..where((t) => t.id.equals(packId)))
        .getSingle();
    // ponytail: animated packs deferred — clear stub path.
    if (pack.animated) {
      throw UnsupportedError('Animated WhatsApp packs not in v1');
    }

    final dir = await getTemporaryDirectory();
    final packDir = Directory(p.join(dir.path, 'wa_pack_$packId'));
    if (await packDir.exists()) await packDir.delete(recursive: true);
    await packDir.create(recursive: true);

    final dio = ApiManager.instance.apiConfigs.dioAdapter;
    final stickerRows = <List<String>>[];
    String? trayPath;
    final base = EnvConfigs.baseUrl.replaceAll(RegExp(r'/$'), '');

    for (var i = 0; i < stickerIds.length; i++) {
      final id = stickerIds[i];
      final url = '$base/api/stickers/$id/media/image';
      final res = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = res.data;
      if (bytes == null) continue;
      final decoded = img.decodeImage(Uint8List.fromList(bytes));
      if (decoded == null) continue;

      final square = img.copyResize(decoded, width: 512, height: 512);
      final outBytes =
          img.encodeWebP(square, lossless: false, quality: 90);
      final filePath = p.join(packDir.path, 'sticker_$i.webp');
      await File(filePath).writeAsBytes(outBytes);

      if (trayPath == null) {
        final tray = img.copyResize(decoded, width: 96, height: 96);
        trayPath = p.join(packDir.path, 'tray.png');
        await File(trayPath).writeAsBytes(img.encodePng(tray));
      }

      await db.into(db.whatsappPackStickers).insert(
            WhatsappPackStickersCompanion.insert(
              packId: packId,
              stickerId: id,
              localPath: filePath,
              sortOrder: Value(i),
            ),
          );

      stickerRows.add([
        WhatsappStickerImage.fromFile(filePath).path,
        '🙂',
      ]);
    }

    if (trayPath == null || stickerRows.isEmpty) {
      throw StateError('No stickers encoded');
    }

    await (db.update(db.whatsappPackDrafts)..where((t) => t.id.equals(packId)))
        .write(WhatsappPackDraftsCompanion(trayPath: Value(trayPath)));

    final exporter = WhatsappStickersExporter();
    await exporter.addStickerPack(
      pack.identifier,
      pack.name,
      pack.publisher,
      WhatsappStickerImage.fromFile(trayPath).path,
      null,
      null,
      null,
      false,
      stickerRows,
    );
  }
}
