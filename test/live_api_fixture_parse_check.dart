import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:blob_flutter/data/models/collections/collection_model.dart';
import 'package:blob_flutter/data/models/legal/legal_model.dart';
import 'package:blob_flutter/data/models/me/me_model.dart';
import 'package:blob_flutter/data/models/prints/print_models.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sticker list card thumbUrl', () {
    final s = StickerModel.fromJson({
      'id': '37',
      'title': 'Rest is Productive',
      'slug': 'rest-is-productive',
      'thumbUrl': '/api/stickers/37/media/thumbnail',
    });
    expect(s.thumbnailUrl, '/api/stickers/37/media/thumbnail');
    expect(s.previewUrl, isNotNull);
  });

  test('sticker detail media array', () {
    final s = StickerModel.fromJson({
      'id': 37,
      'title': 'Rest',
      'moderationStatus': 'approved',
      'media': [
        {'kind': 'image', 'url': '/api/stickers/37/media/image'},
        {'kind': 'thumbnail', 'url': '/api/stickers/37/media/thumbnail'},
        {'kind': 'chat', 'url': '/api/stickers/37/media/chat'},
      ],
    });
    expect(s.id, '37');
    expect(s.status, 'approved');
    expect(s.imageUrl, endsWith('/image'));
    expect(s.chatUrl, endsWith('/chat'));
  });

  test('search hits via cursorPage', () {
    final page = ApiParse.cursorPage(
      {
        'engine': 'meili',
        'hits': [
          {
            'id': '33',
            'title': 'TopText Party Cat',
            'slug': 'toptext-party-cat',
            'previewUrl':
                'https://blob.mamajees.com/api/stickers/33/media/thumbnail',
          },
        ],
      },
      StickerModel.fromJson,
    );
    expect(page.items, hasLength(1));
    expect(page.items.first.previewUrl, contains('thumbnail'));
  });

  test('sheet name → title', () {
    final s = SheetModel.fromJson({
      'id': '7',
      'name': 'Hank My Boiii',
      'slug': 'hank-my-boiii',
      'status': 'ready',
      'previewUrl': '/api/sheets/7/media/png',
    });
    expect(s.displayTitle, 'Hank My Boiii');
    expect(s.id, '7');
  });

  test('collection name + preview thumbs', () {
    final c = CollectionModel.fromJson({
      'id': '3',
      'name': 'admin collection',
      'slug': 'admin-collection',
      'stickerCount': 7,
      'previewThumbUrls': ['/api/stickers/13/media/thumbnail'],
    });
    expect(c.displayTitle, 'admin collection');
    expect(c.itemCount, 7);
    expect(c.coverUrl, isNotNull);
  });

  test('legal about tagline list joins', () {
    final doc = LegalDocument.fromJson({
      'slug': 'about',
      'title': 'About',
      'tagline': ['a library', 'of stickers'],
      'lead': 'BLOB is…',
      'sections': [
        {
          'heading': 'Hi',
          'paragraphs': ['one'],
        },
      ],
    });
    expect(doc.tagline, 'a library of stickers');
    expect(doc.sections, hasLength(1));
  });

  test('me appGroup object → key', () {
    final me = MeModel.fromJson({
      'id': '1',
      'username': 'ada',
      'role': 'member',
      'accountStatus': 'active',
      'appGroup': {'key': 'public', 'name': 'Public'},
    });
    expect(me.appGroup, 'public');
  });

  test('isNumericId', () {
    expect(ApiParse.isNumericId('37'), isTrue);
    expect(ApiParse.isNumericId('rest-is-productive'), isFalse);
  });
}
