import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/data/repositories/preferences/shared_prefs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSettingsState extends Equatable {
  const AppSettingsState({this.navRailSide = NavRailSide.right});

  final NavRailSide navRailSide;

  AppSettingsState copyWith({NavRailSide? navRailSide}) =>
      AppSettingsState(navRailSide: navRailSide ?? this.navRailSide);

  @override
  List<Object?> get props => [navRailSide];
}

class AppSettingsCubit extends Cubit<AppSettingsState> with XSafeEmitMixin {
  AppSettingsCubit()
    : super(AppSettingsState(navRailSide: sharedPrefs.navRailSide));

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
}
