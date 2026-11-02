import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('list card maps thumbUrl', () {
    final s = StickerModel.fromJson({
      'id': '37',
      'title': 'Rest',
      'slug': 'rest',
      'thumbUrl': '/api/stickers/37/media/thumbnail',
    });
    expect(s.thumbnailUrl, '/api/stickers/37/media/thumbnail');
    expect(s.previewUrl, '/api/stickers/37/media/thumbnail');
  });

  test('detail maps media list kinds', () {
    final s = StickerModel.fromJson({
      'id': 37,
      'title': 'Rest',
      'media': [
        {'kind': 'image', 'url': '/api/stickers/37/media/image'},
        {'kind': 'thumbnail', 'url': '/api/stickers/37/media/thumbnail'},
        {'kind': 'chat', 'url': '/api/stickers/37/media/chat'},
      ],
    });
    expect(s.id, '37');
    expect(s.imageUrl, '/api/stickers/37/media/image');
    expect(s.thumbnailUrl, '/api/stickers/37/media/thumbnail');
    expect(s.chatUrl, '/api/stickers/37/media/chat');
  });
}
