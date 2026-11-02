import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ApiParse.cursorPage maps items + nextCursor', () {
    final page = ApiParse.cursorPage(
      {
        'items': [
          {'id': '1', 'name': 'a'},
          {'id': '2', 'name': 'b'},
        ],
        'nextCursor': 'abc',
      },
      (m) => m['id'] as String,
    );
    expect(page.items, ['1', '2']);
    expect(page.nextCursor, 'abc');
  });

  test('ApiParse.absoluteUrl leaves absolute URLs alone', () {
    expect(
      ApiParse.absoluteUrl('https://example.com/x'),
      'https://example.com/x',
    );
  });
}
