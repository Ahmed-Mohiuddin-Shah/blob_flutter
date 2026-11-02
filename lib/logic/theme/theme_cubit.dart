import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/data/repositories/preferences/shared_prefs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({this.themeMode = ThemeMode.system});

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

class ThemeCubit extends Cubit<ThemeState> with XSafeEmitMixin {
  ThemeCubit() : super(ThemeState(themeMode: _fromPrefs()));

  static ThemeMode _fromPrefs() {
    switch (sharedPrefs.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final key = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await sharedPrefs.setThemeMode(key);
    xSafeEmit(ThemeState(themeMode: mode));
  }
}
