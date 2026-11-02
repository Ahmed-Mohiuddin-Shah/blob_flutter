import 'package:blob_flutter/configs/routes/navigator_key.dart';
import 'package:blob_flutter/configs/routes/pending_deep_link.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/configs/utils/deeplinks/deep_link_mapper.dart';
import 'package:blob_flutter/logic/home/home_navigation_cubit.dart';
import 'package:blob_flutter/presentation/settings/settings_view.dart';
import 'package:blob_flutter/presentation/shell/adaptive_nav_shell.dart';
import 'package:blob_flutter/presentation/splash/splash_view.dart';
import 'package:blob_flutter/presentation/widgets/placeholder_detail_view.dart';
import 'package:blob_flutter/presentation/widgets/placeholder_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

NoTransitionPage<void> _tabPage(Widget child) =>
    NoTransitionPage<void>(child: child);

GoRouterPageBuilder _detail(String title, {String? param}) {
  return (context, state) {
    final value = param == null ? null : state.pathParameters[param];
    return MaterialPage<void>(
      child: PlaceholderDetailView(title: title, subtitle: value),
    );
  };
}

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteNames.splash,
  redirect: (context, state) {
    final uri = state.uri;

    // Custom-scheme OAuth returns must not be routed by go_router.
    if (uri.scheme.startsWith('com.mamajees.blob.app')) {
      return RouteNames.splash;
    }

    final mapped = DeepLinkMapper.toAppLocation(uri);

    // Cold-start / warm App Link before splash finishes → stash, show splash.
    if (!PendingDeepLink.homeReady &&
        state.matchedLocation != RouteNames.splash &&
        mapped != RouteNames.splash) {
      PendingDeepLink.set(mapped);
      return RouteNames.splash;
    }

    // Remap web-only / aliases (e.g. `/` → `/stickers`, `/admin` → home).
    final current =
        uri.hasQuery ? '${uri.path}?${uri.query}' : (uri.path.isEmpty ? '/' : uri.path);
    if (mapped != current &&
        mapped != state.matchedLocation &&
        state.matchedLocation != RouteNames.splash) {
      return mapped;
    }
    if (uri.path == '/' || uri.path.isEmpty) {
      if (PendingDeepLink.homeReady) return RouteNames.home;
    }
    return null;
  },
  errorBuilder: (context, state) => const PlaceholderDetailView(
    title: 'Home',
    subtitle: 'Unknown link — sent home',
  ),
  onException: (context, state, router) {
    router.go(RouteNames.home);
  },
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashView(),
    ),

    // —— Main tabs (adaptive shell) ——
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => AdaptiveNavShell(child: child),
      routes: [
        GoRoute(
          path: RouteNames.stickers,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.stickers);
            return _tabPage(const PlaceholderTabView(title: 'Stickers'));
          },
        ),
        GoRoute(
          path: RouteNames.blobbers,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.blobbers);
            return _tabPage(const PlaceholderTabView(title: 'Blobbers'));
          },
        ),
        GoRoute(
          path: RouteNames.prints,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.prints);
            return _tabPage(const PlaceholderTabView(title: 'Prints'));
          },
        ),
        GoRoute(
          path: RouteNames.collections,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.collections);
            return _tabPage(const PlaceholderTabView(title: 'Collections'));
          },
        ),
        GoRoute(
          path: RouteNames.search,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.search);
            final q = state.uri.queryParameters['q'];
            return _tabPage(
              PlaceholderTabView(
                title: q == null || q.isEmpty ? 'Search' : 'Search: $q',
              ),
            );
          },
        ),
      ],
    ),

    // —— Stickers detail / editor ——
    GoRoute(
      path: '/stickers/:slug/edit',
      pageBuilder: _detail('Edit sticker', param: 'slug'),
    ),
    GoRoute(
      path: '/stickers/:slug/compose',
      pageBuilder: _detail('Compose', param: 'slug'),
    ),
    GoRoute(
      path: '/stickers/:slug/remix',
      pageBuilder: _detail('Remix', param: 'slug'),
    ),
    GoRoute(
      path: '/stickers/:slug',
      pageBuilder: _detail('Sticker', param: 'slug'),
    ),

    // —— Collections ——
    GoRoute(
      path: RouteNames.collectionsNew,
      pageBuilder: _detail('New collection'),
    ),
    GoRoute(
      path: '/collections/:slug',
      pageBuilder: _detail('Collection', param: 'slug'),
    ),

    // —— Prints ——
    GoRoute(
      path: RouteNames.printsSheetsNew,
      pageBuilder: _detail('New sheet'),
    ),
    GoRoute(
      path: RouteNames.printsPacksNew,
      pageBuilder: _detail('New pack'),
    ),
    GoRoute(
      path: '/prints/sheets/:slug',
      pageBuilder: _detail('Sheet', param: 'slug'),
    ),
    GoRoute(
      path: '/prints/packs/:slug',
      pageBuilder: _detail('Pack', param: 'slug'),
    ),

    // —— Blobbers ——
    GoRoute(
      path: '/blobbers/id/:id',
      pageBuilder: _detail('Blobber', param: 'id'),
    ),
    GoRoute(
      path: '/blobbers/:slug',
      pageBuilder: _detail('Blobber', param: 'slug'),
    ),

    // —— Legal / upload / profile ——
    GoRoute(path: RouteNames.about, pageBuilder: _detail('About')),
    GoRoute(path: RouteNames.terms, pageBuilder: _detail('Terms')),
    GoRoute(path: RouteNames.privacy, pageBuilder: _detail('Privacy')),
    GoRoute(path: RouteNames.upload, pageBuilder: _detail('Upload')),
    GoRoute(path: RouteNames.profile, pageBuilder: _detail('Profile')),
    GoRoute(path: RouteNames.favourites, pageBuilder: _detail('Favourites')),
    GoRoute(path: RouteNames.uploads, pageBuilder: _detail('Uploads')),
    GoRoute(path: RouteNames.profilePrints, pageBuilder: _detail('My prints')),
    GoRoute(
      path: RouteNames.settings,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: RouteNames.profileBlobber,
      pageBuilder: _detail('Blobber CMS'),
    ),
    GoRoute(
      path: RouteNames.profileBlobberAssociate,
      pageBuilder: _detail('Associate blobber'),
    ),

    // Legacy alias
    GoRoute(
      path: '/settings',
      redirect: (context, state) => RouteNames.settings,
    ),
  ],
);
