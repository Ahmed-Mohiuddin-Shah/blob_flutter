import 'package:flutter/services.dart';

import 'exceptions.dart';

class WhatsappStickersExporter {
  static const consumerWhatsAppPackageName = 'com.whatsapp';
  static const businessWhatsAppPackageName = 'com.whatsapp.w4b';
  static const MethodChannel _channel =
      MethodChannel('whatsapp_stickers_exporter');

  /// Launch WhatsApp (Android only).
  static Future<void> launchWhatsApp() =>
      _channel.invokeMethod<void>('launchWhatsApp');

  /// Add a sticker pack to WhatsApp.
  Future<void> addStickerPack(
    String identifier,
    String name,
    String publisher,
    String trayImageFileName,
    String? publisherWebsite,
    String? privacyPolicyWebsite,
    String? licenseAgreementWebsite,
    bool? animatedStickerPack,
    List<List<String>> stickers,
  ) async {
    try {
      await _channel.invokeMethod<void>('addStickerPack', <String, dynamic>{
        'identifier': identifier,
        'name': name,
        'publisher': publisher,
        'trayImageFileName': trayImageFileName,
        'publisherWebsite': publisherWebsite,
        'privacyPolicyWebsite': privacyPolicyWebsite,
        'licenseAgreementWebsite': licenseAgreementWebsite,
        'animatedStickerPack': animatedStickerPack,
        'stickers': stickers,
      });
    } on PlatformException catch (e) {
      throw _mapPlatformException(e);
    }
  }
}

WhatsappStickersException _mapPlatformException(PlatformException e) {
  switch (e.code) {
    case WhatsappStickersFileNotFoundException.CODE:
      return WhatsappStickersFileNotFoundException(e.message);
    case WhatsappStickersNumOutsideAllowableRangeException.CODE:
      return WhatsappStickersNumOutsideAllowableRangeException(e.message);
    case WhatsappStickersUnsupportedImageFormatException.CODE:
      return WhatsappStickersUnsupportedImageFormatException(e.message);
    case WhatsappStickersImageTooBigException.CODE:
      return WhatsappStickersImageTooBigException(e.message);
    case WhatsappStickersIncorrectImageSizeException.CODE:
      return WhatsappStickersIncorrectImageSizeException(e.message);
    case WhatsappStickersTooManyEmojisException.CODE:
      return WhatsappStickersTooManyEmojisException(e.message);
    case WhatsappStickersEmptyStringException.CODE:
      return WhatsappStickersEmptyStringException(e.message);
    case WhatsappStickersStringTooLongException.CODE:
      return WhatsappStickersStringTooLongException(e.message);
    default:
      return WhatsappStickersException(e.message);
  }
}

class WhatsappStickerImage {
  WhatsappStickerImage._(this.path);

  final String path;

  factory WhatsappStickerImage.fromAsset(String asset) =>
      WhatsappStickerImage._('assets://$asset');

  factory WhatsappStickerImage.fromFile(String file) =>
      WhatsappStickerImage._('file://$file');
}
