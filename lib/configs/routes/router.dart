import 'package:blob_flutter/configs/routes/navigator_key.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/home/home_navigation_cubit.dart';
import 'package:blob_flutter/presentation/settings/settings_view.dart';
import 'package:blob_flutter/presentation/shell/adaptive_nav_shell.dart';
import 'package:blob_flutter/presentation/splash/splash_view.dart';
import 'package:blob_flutter/presentation/widgets/placeholder_tab_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: RouteNames.settings,
      builder: (context, state) => const SettingsView(),
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => AdaptiveNavShell(child: child),
      routes: [
        GoRoute(
          path: RouteNames.stickers,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.stickers);
            return const NoTransitionPage(
              child: PlaceholderTabView(title: 'Stickers'),
            );
          },
        ),
        GoRoute(
          path: RouteNames.blobbers,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.blobbers);
            return const NoTransitionPage(
              child: PlaceholderTabView(title: 'Blobbers'),
            );
          },
        ),
        GoRoute(
          path: RouteNames.prints,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.prints);
            return const NoTransitionPage(
              child: PlaceholderTabView(title: 'Prints'),
            );
          },
        ),
        GoRoute(
          path: RouteNames.collections,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.collections);
            return const NoTransitionPage(
              child: PlaceholderTabView(title: 'Collections'),
            );
          },
        ),
        GoRoute(
          path: RouteNames.search,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.search);
            return const NoTransitionPage(
              child: PlaceholderTabView(title: 'Search'),
            );
          },
        ),
      ],
    ),
  ],
);
