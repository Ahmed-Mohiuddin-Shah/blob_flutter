import 'package:blob_flutter/logic/app_settings/app_settings_cubit.dart';
import 'package:blob_flutter/logic/app_version/app_version_cubit.dart';
import 'package:blob_flutter/logic/auth/auth_cubit.dart';
import 'package:blob_flutter/logic/home/home_navigation_cubit.dart';
import 'package:blob_flutter/logic/me/me_cubit.dart';
import 'package:blob_flutter/logic/theme/theme_cubit.dart';

abstract final class AppGlobals {
  const AppGlobals._();

  static HomeNavigationCubit? _homeNavigationCubit;
  static HomeNavigationCubit get homeNavigationCubit =>
      _homeNavigationCubit ??= HomeNavigationCubit();

  static AppSettingsCubit? _appSettingsCubit;
  static AppSettingsCubit get appSettingsCubit =>
      _appSettingsCubit ??= AppSettingsCubit();

  static ThemeCubit? _themeCubit;
  static ThemeCubit get themeCubit => _themeCubit ??= ThemeCubit();

  static AppVersionCubit? _appVersionCubit;
  static AppVersionCubit get appVersionCubit =>
      _appVersionCubit ??= AppVersionCubit();

  static AuthCubit? _authCubit;
  static AuthCubit get authCubit => _authCubit ??= AuthCubit();

  static MeCubit? _meCubit;
  static MeCubit get meCubit => _meCubit ??= MeCubit();
}
