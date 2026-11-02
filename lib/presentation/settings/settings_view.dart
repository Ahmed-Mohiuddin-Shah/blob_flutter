import 'package:blob_flutter/configs/app/global/app_globals.dart';
import 'package:blob_flutter/data/repositories/preferences/shared_prefs.dart';
import 'package:blob_flutter/logic/app_settings/app_settings_cubit.dart';
import 'package:blob_flutter/logic/auth/auth_cubit.dart';
import 'package:blob_flutter/logic/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          BlocBuilder<AppSettingsCubit, AppSettingsState>(
            builder: (context, state) {
              return SwitchListTile(
                title: const Text('Nav rail on left (landscape)'),
                subtitle: Text(
                  state.navRailSide == NavRailSide.left
                      ? 'Left'
                      : 'Right (default)',
                ),
                value: state.navRailSide == NavRailSide.left,
                onChanged: (left) {
                  context.read<AppSettingsCubit>().setNavRailSide(
                        left ? NavRailSide.left : NavRailSide.right,
                      );
                },
              );
            },
          ),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return ListTile(
                title: const Text('Theme'),
                subtitle: Text(state.themeMode.name),
                trailing: DropdownButton<ThemeMode>(
                  value: state.themeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      context.read<ThemeCubit>().setThemeMode(mode);
                    }
                  },
                ),
              );
            },
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final signedIn = state.status == AuthStatus.signedIn;
              return ListTile(
                title: Text(signedIn ? 'Sign out' : 'Sign in'),
                subtitle: Text(state.status.name),
                trailing: state.busy
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                onTap: state.busy
                    ? null
                    : () async {
                        if (signedIn) {
                          await context.read<AuthCubit>().signOut();
                          AppGlobals.meCubit.clear();
                        } else {
                          final ok = await context.read<AuthCubit>().signIn();
                          if (ok) await AppGlobals.meCubit.load();
                        }
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
