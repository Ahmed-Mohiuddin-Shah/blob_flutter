import 'package:shared_preferences/shared_preferences.dart';

enum NavRailSide { left, right }

class SharedPrefs {
  SharedPreferences? _prefs;

  SharedPreferences? get instance => _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static const _navRailSideKey = 'navRailSide';
  static const _themeModeKey = 'themeMode';
  static const _onboardingKey = 'isOnboardingComplete';

  NavRailSide get navRailSide {
    final raw = _prefs?.getString(_navRailSideKey);
    return raw == NavRailSide.left.name ? NavRailSide.left : NavRailSide.right;
  }

  Future<bool> setNavRailSide(NavRailSide side) =>
      _prefs!.setString(_navRailSideKey, side.name);

  /// `system` | `light` | `dark`
  String get themeMode => _prefs?.getString(_themeModeKey) ?? 'system';

  Future<bool> setThemeMode(String mode) =>
      _prefs!.setString(_themeModeKey, mode);

  bool get isOnboardingComplete => _prefs?.getBool(_onboardingKey) ?? false;

  Future<bool> completeOnboarding() => _prefs!.setBool(_onboardingKey, true);
}

final SharedPrefs sharedPrefs = SharedPrefs();
