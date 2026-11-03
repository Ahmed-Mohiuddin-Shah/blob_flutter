import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/data/repositories/preferences/shared_prefs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.navRailSide = NavRailSide.right,
    this.locale,
  });

  final NavRailSide navRailSide;

  /// `null` = follow device locale.
  final Locale? locale;

  AppSettingsState copyWith({
    NavRailSide? navRailSide,
    Locale? locale,
    bool clearLocale = false,
  }) => AppSettingsState(
    navRailSide: navRailSide ?? this.navRailSide,
    locale: clearLocale ? null : (locale ?? this.locale),
  );

  @override
  List<Object?> get props => [navRailSide, locale];
}

class AppSettingsCubit extends Cubit<AppSettingsState> with XSafeEmitMixin {
  AppSettingsCubit()
    : super(
        AppSettingsState(
          navRailSide: sharedPrefs.navRailSide,
          locale: _localeFromCode(sharedPrefs.localeCode),
        ),
      );

  static Locale? _localeFromCode(String? code) {
    if (code == null) return null;
    return Locale(code);
  }

  Future<void> setNavRailSide(NavRailSide side) async {
    await sharedPrefs.setNavRailSide(side);
    xSafeEmit(state.copyWith(navRailSide: side));
  }

  void toggleNavRailSide() {
    final next = state.navRailSide == NavRailSide.right
        ? NavRailSide.left
        : NavRailSide.right;
    setNavRailSide(next);
  }

  /// Pass `null` for system / device locale.
  Future<void> setLocale(Locale? locale) async {
    await sharedPrefs.setLocaleCode(locale?.languageCode);
    xSafeEmit(
      locale == null
          ? state.copyWith(clearLocale: true)
          : state.copyWith(locale: locale),
    );
  }

  /// Flip en ↔ ur (from system, pick the other of en).
  Future<void> toggleLanguage() {
    final code = state.locale?.languageCode;
    if (code == 'ur') return setLocale(const Locale('en'));
    return setLocale(const Locale('ur'));
  }
}
