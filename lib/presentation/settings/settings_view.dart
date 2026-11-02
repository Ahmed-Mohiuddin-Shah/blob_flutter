import 'package:blob_flutter/configs/app/global/app_globals.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/data/repositories/preferences/shared_prefs.dart';
import 'package:blob_flutter/logic/app_settings/app_settings_cubit.dart';
import 'package:blob_flutter/logic/auth/auth_cubit.dart';
import 'package:blob_flutter/logic/theme/theme_cubit.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// NavRailSide comes from shared_prefs.dart via AppSettingsCubit.

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlobScaffold(
      title: 'settings',
      showSettings: false,
      slivers: [
        const SliverToBoxAdapter(
          child: SectionHeader(eyebrow: 'Prefs', title: 'settings'),
        ),
        SliverToBoxAdapter(
          child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
            builder: (context, state) {
              return SwitchListTile(
                title: const Text('Nav rail on left (landscape)'),
                subtitle: Text(
                  state.navRailSide == NavRailSide.left ? 'Left' : 'Right',
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
        ),
        SpiverThemeTile(),
        SpiverAuthTile(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => context.push(RouteNames.about),
                  child: const Text('About'),
                ),
                TextButton(
                  onPressed: () => context.push(RouteNames.terms),
                  child: const Text('Terms'),
                ),
                TextButton(
                  onPressed: () => context.push(RouteNames.privacy),
                  child: const Text('Privacy'),
                ),
                TextButton(
                  onPressed: () => context.push(RouteNames.profile),
                  child: const Text('Profile'),
                ),
                TextButton(
                  onPressed: () => context.push('/whatsapp-export'),
                  child: const Text('WhatsApp export'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SpiverThemeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<ThemeCubit, ThemeState>(
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
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
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
    );
  }
}

class SpiverAuthTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final signedIn = state.status == AuthStatus.signedIn;
          return ListTile(
            title: Text(signedIn ? 'Sign out' : 'Sign in'),
            subtitle: Text(state.error ?? state.status.name),
            trailing: state.busy
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : BusyButton(
                    label: signedIn ? 'Out' : 'In',
                    busy: state.busy,
                    onPressed: () async {
                      if (signedIn) {
                        await context.read<AuthCubit>().signOut();
                        AppGlobals.meCubit.clear();
                      } else {
                        final ok = await context.read<AuthCubit>().signIn();
                        if (ok) await AppGlobals.meCubit.load();
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
