import 'package:blob_flutter/configs/routes/navigator_key.dart';
import 'package:blob_flutter/configs/routes/pending_deep_link.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/configs/utils/deeplinks/deep_link_mapper.dart';
import 'package:blob_flutter/logic/home/home_navigation_cubit.dart';
import 'package:blob_flutter/presentation/blobbers/blobbers_view.dart';
import 'package:blob_flutter/presentation/collections/collections_view.dart';
import 'package:blob_flutter/presentation/editor/editor_host_view.dart';
import 'package:blob_flutter/presentation/favourites/favourites_view.dart';
import 'package:blob_flutter/presentation/legal/legal_view.dart';
import 'package:blob_flutter/presentation/prints/prints_view.dart';
import 'package:blob_flutter/presentation/profile/profile_view.dart';
import 'package:blob_flutter/presentation/search/search_view.dart';
import 'package:blob_flutter/presentation/settings/settings_view.dart';
import 'package:blob_flutter/presentation/shell/adaptive_nav_shell.dart';
import 'package:blob_flutter/presentation/splash/splash_view.dart';
import 'package:blob_flutter/presentation/stickers/sticker_detail_view.dart';
import 'package:blob_flutter/presentation/stickers/sticker_edit_view.dart';
import 'package:blob_flutter/presentation/stickers/stickers_view.dart';
import 'package:blob_flutter/presentation/stickers/upload_gate_view.dart';
import 'package:blob_flutter/presentation/whatsapp/whatsapp_export_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

NoTransitionPage<void> _tabPage(Widget child) =>
    NoTransitionPage<void>(child: child);

bool _isOAuthCallback(GoRouterState state) {
  final raw = state.uri.toString();
  final path = state.uri.path;
  final scheme = state.uri.scheme;
  return path == '/oauthredirect' ||
      raw.contains('oauthredirect') ||
      scheme.startsWith('com.mamajees.blob.app');
}

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteNames.splash,
  redirect: (context, state) {
    if (_isOAuthCallback(state)) {
      return PendingDeepLink.homeReady ? RouteNames.home : RouteNames.splash;
    }

    final uri = state.uri;
    final mapped = DeepLinkMapper.toAppLocation(uri);

    if (uri.path.isEmpty || uri.path == '/') {
      return PendingDeepLink.homeReady ? RouteNames.home : RouteNames.splash;
    }

    if (!PendingDeepLink.homeReady &&
        state.matchedLocation != RouteNames.splash &&
        mapped != RouteNames.splash) {
      PendingDeepLink.set(mapped);
      return RouteNames.splash;
    }

    final current = uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
    if (mapped != current &&
        mapped != state.matchedLocation &&
        state.matchedLocation != RouteNames.splash) {
      return mapped;
    }
    return null;
  },
  // go_router allows only one of onException / errorBuilder / errorPageBuilder.
  onException: (context, state, router) {
    router.go(PendingDeepLink.homeReady ? RouteNames.home : RouteNames.splash);
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) =>
          PendingDeepLink.homeReady ? RouteNames.home : RouteNames.splash,
    ),
    GoRoute(
      path: '/oauthredirect',
      redirect: (context, state) =>
          PendingDeepLink.homeReady ? RouteNames.home : RouteNames.splash,
    ),
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashView(),
    ),

    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => AdaptiveNavShell(child: child),
      routes: [
        GoRoute(
          path: RouteNames.stickers,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.stickers);
            return _tabPage(const StickersView());
          },
        ),
        GoRoute(
          path: RouteNames.blobbers,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.blobbers);
            return _tabPage(const BlobbersView());
          },
        ),
        GoRoute(
          path: RouteNames.prints,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.prints);
            return _tabPage(const PrintsView());
          },
        ),
        GoRoute(
          path: RouteNames.collections,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.collections);
            return _tabPage(const CollectionsView());
          },
        ),
        GoRoute(
          path: RouteNames.search,
          pageBuilder: (context, state) {
            context.read<HomeNavigationCubit>().select(HomeTab.search);
            return _tabPage(
              SearchView(initialQuery: state.uri.queryParameters['q']),
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: '/stickers/:slug/edit',
      builder: (context, state) => StickerEditView(
        idOrSlug: state.pathParameters['slug']!,
      ),
    ),
    GoRoute(
      path: '/stickers/:slug/compose',
      builder: (context, state) => EditorHostView(
        idOrSlug: state.pathParameters['slug']!,
        mode: EditorMode.compose,
      ),
    ),
    GoRoute(
      path: '/stickers/:slug/remix',
      builder: (context, state) => EditorHostView(
        idOrSlug: state.pathParameters['slug']!,
        mode: EditorMode.remix,
      ),
    ),
    GoRoute(
      path: '/stickers/:slug',
      builder: (context, state) => StickerDetailView(
        idOrSlug: state.pathParameters['slug']!,
      ),
    ),

    GoRoute(
      path: RouteNames.collectionsNew,
      builder: (context, state) => const CollectionCreateView(),
    ),
    GoRoute(
      path: '/collections/:slug',
      builder: (context, state) => CollectionDetailView(
        slug: state.pathParameters['slug']!,
      ),
    ),

    GoRoute(
      path: RouteNames.printsSheetsNew,
      builder: (context, state) => const PrintCreateView(kind: 'sheet'),
    ),
    GoRoute(
      path: RouteNames.printsPacksNew,
      builder: (context, state) => const PrintCreateView(kind: 'pack'),
    ),
    GoRoute(
      path: '/prints/sheets/:slug',
      builder: (context, state) => PrintDetailView(
        id: state.pathParameters['slug']!,
        isSheet: true,
      ),
    ),
    GoRoute(
      path: '/prints/packs/:slug',
      builder: (context, state) => PrintDetailView(
        id: state.pathParameters['slug']!,
        isSheet: false,
      ),
    ),

    GoRoute(
      path: '/blobbers/id/:id',
      builder: (context, state) => BlobberDetailView(
        idOrSlug: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/blobbers/:slug',
      builder: (context, state) => BlobberDetailView(
        idOrSlug: state.pathParameters['slug']!,
      ),
    ),

    GoRoute(
      path: RouteNames.about,
      builder: (context, state) => const LegalView(slug: 'about'),
    ),
    GoRoute(
      path: RouteNames.terms,
      builder: (context, state) => const LegalView(slug: 'terms'),
    ),
    GoRoute(
      path: RouteNames.privacy,
      builder: (context, state) => const LegalView(slug: 'privacy'),
    ),
    GoRoute(
      path: RouteNames.upload,
      builder: (context, state) => const UploadGateView(),
    ),
    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: RouteNames.favourites,
      builder: (context, state) => const FavouritesView(),
    ),
    GoRoute(
      path: RouteNames.uploads,
      builder: (context, state) => const LibraryView(title: 'uploads'),
    ),
    GoRoute(
      path: RouteNames.profilePrints,
      builder: (context, state) =>
          const LibraryView(title: 'prints', status: 'approved'),
    ),
    GoRoute(
      path: RouteNames.settings,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: RouteNames.profileBlobber,
      builder: (context, state) => const BlobberCmsView(),
    ),
    GoRoute(
      path: RouteNames.profileBlobberAssociate,
      builder: (context, state) => const BlobberAssociateView(),
    ),
    GoRoute(
      path: '/whatsapp-export',
      builder: (context, state) => const WhatsappExportView(),
    ),
    GoRoute(
      path: '/settings',
      redirect: (context, state) => RouteNames.settings,
    ),
  ],
);
