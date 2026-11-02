import 'package:blob_flutter/configs/app/global/app_colors.dart';
import 'package:blob_flutter/configs/app/global/env_configs.dart';
import 'package:blob_flutter/configs/routes/router.dart';
import 'package:blob_flutter/data/local/app_database.dart';
import 'package:blob_flutter/data/repositories/preferences/shared_prefs.dart';
import 'package:blob_flutter/logic/theme/theme_cubit.dart';
import 'package:blob_flutter/multiple_bloc_provider.dart';
import 'package:blob_flutter/services/measure_bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfigs.init();
  await sharedPrefs.init();
  // Touch Drift early so schema is ready for WhatsApp drafts.
  appDatabase;
  await runWithMeasure(const MultipleBlocProviders(child: BlobApp()));
}

class BlobApp extends StatelessWidget {
  const BlobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          title: 'BLOB',
          debugShowCheckedModeBanner: false,
          themeMode: themeState.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.accentPink,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: AppColors.backgroundLight,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.accentPink,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: AppColors.backgroundDark,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
