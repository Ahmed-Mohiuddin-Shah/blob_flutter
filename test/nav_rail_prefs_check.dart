import 'package:blob_flutter/data/repositories/preferences/shared_prefs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ponytail: one runnable check — nav rail side roundtrips via SharedPrefs.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('navRailSide defaults right and persists left', () async {
    SharedPreferences.setMockInitialValues({});
    await sharedPrefs.init();
    expect(sharedPrefs.navRailSide, NavRailSide.right);
    await sharedPrefs.setNavRailSide(NavRailSide.left);
    expect(sharedPrefs.navRailSide, NavRailSide.left);
  });
}
