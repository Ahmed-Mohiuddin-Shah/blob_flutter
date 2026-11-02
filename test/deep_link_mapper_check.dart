import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/configs/utils/deeplinks/deep_link_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deep link map: home, detail, admin→home, auth→settings', () {
    expect(
      DeepLinkMapper.toAppLocation(Uri.parse('https://blob.mamajees.com/')),
      RouteNames.home,
    );
    expect(
      DeepLinkMapper.toAppLocation(
        Uri.parse('https://blob.mamajees.com/stickers/cool-blob'),
      ),
      '/stickers/cool-blob',
    );
    expect(
      DeepLinkMapper.toAppLocation(
        Uri.parse('https://blob.mamajees.com/admin/users'),
      ),
      RouteNames.home,
    );
    expect(
      DeepLinkMapper.toAppLocation(
        Uri.parse('https://blob.mamajees.com/search?q=hi'),
      ),
      '/search?q=hi',
    );
    expect(
      DeepLinkMapper.toAppLocation(
        Uri.parse('https://blob.mamajees.com/profile/settings'),
      ),
      RouteNames.settings,
    );
  });
}
