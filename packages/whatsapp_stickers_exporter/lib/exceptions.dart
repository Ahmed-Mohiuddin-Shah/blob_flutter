class WhatsappStickersException implements Exception {
  WhatsappStickersException(this.cause);

  final String? cause;

  @override
  String toString() =>
      cause == null || cause!.isEmpty ? '$runtimeType' : '$runtimeType: $cause';
}

class WhatsappStickersFileNotFoundException extends WhatsappStickersException {
  // ignore: constant_identifier_names — matches native PlatformException codes
  static const String CODE = 'FILE_NOT_FOUND';

  WhatsappStickersFileNotFoundException(super.cause);
}

class WhatsappStickersNumOutsideAllowableRangeException
    extends WhatsappStickersException {
  // ignore: constant_identifier_names
  static const String CODE = 'OUTSIDE_ALLOWABLE_RANGE';

  WhatsappStickersNumOutsideAllowableRangeException(super.cause);
}

class WhatsappStickersUnsupportedImageFormatException
    extends WhatsappStickersException {
  // ignore: constant_identifier_names
  static const String CODE = 'UNSUPPORTED_IMAGE_FORMAT';

  WhatsappStickersUnsupportedImageFormatException(super.cause);
}

class WhatsappStickersImageTooBigException extends WhatsappStickersException {
  // ignore: constant_identifier_names
  static const String CODE = 'IMAGE_TOO_BIG';

  WhatsappStickersImageTooBigException(super.cause);
}

class WhatsappStickersIncorrectImageSizeException
    extends WhatsappStickersException {
  // ignore: constant_identifier_names
  static const String CODE = 'INCORRECT_IMAGE_SIZE';

  WhatsappStickersIncorrectImageSizeException(super.cause);
}

class WhatsappStickersTooManyEmojisException extends WhatsappStickersException {
  // ignore: constant_identifier_names
  static const String CODE = 'TOO_MANY_EMOJIS';

  WhatsappStickersTooManyEmojisException(super.cause);
}

class WhatsappStickersEmptyStringException extends WhatsappStickersException {
  // ignore: constant_identifier_names
  static const String CODE = 'EMPTY_STRING';

  WhatsappStickersEmptyStringException(super.cause);
}

class WhatsappStickersStringTooLongException extends WhatsappStickersException {
  // ignore: constant_identifier_names
  static const String CODE = 'STRING_TOO_LONG';

  WhatsappStickersStringTooLongException(super.cause);
}
