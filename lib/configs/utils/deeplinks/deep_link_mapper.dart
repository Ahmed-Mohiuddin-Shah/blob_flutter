import 'package:blob_flutter/configs/app/global/app_globals.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/auth/auth_cubit.dart';

/// Maps web / App Link paths → in-app go_router locations. Unknown → home.
abstract final class DeepLinkMapper {
  const DeepLinkMapper._();

  static bool get _signedIn =>
      AppGlobals.authCubit.state.status == AuthStatus.signedIn;

  /// Full location including query when relevant (e.g. `/search?q=`).
  static String toAppLocation(Uri uri) {
    final path = _normalizePath(uri.path);
    final mapped = _mapPath(path);
    if (mapped == RouteNames.search && uri.hasQuery) {
      return '${RouteNames.search}?${uri.query}';
    }
    return mapped;
  }

  static String _normalizePath(String raw) {
    var path = raw.trim();
    if (path.isEmpty) return '/';
    if (!path.startsWith('/')) path = '/$path';
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  static String _mapPath(String path) {
    // AppAuth callback path if Flutter ever sees it without the custom scheme.
    if (path == '/oauthredirect') return RouteNames.home;

    // Web auth / logout — native PKCE only.
    if (path == '/auth/login') {
      return _signedIn ? RouteNames.home : RouteNames.settings;
    }
    if (path.startsWith('/auth/') ||
        path == '/logout' ||
        path.startsWith('/logout/')) {
      return RouteNames.home;
    }

    // Admin / web-only → home.
    if (_isWebOnly(path)) return RouteNames.home;

    if (path == '/' || path.isEmpty) return RouteNames.home;

    // Exact + prefix matches (specific before :param).
    if (path == RouteNames.stickers) return RouteNames.stickers;
    if (path == RouteNames.collections) return RouteNames.collections;
    if (path == RouteNames.collectionsNew) {
      return _signedIn ? RouteNames.collectionsNew : RouteNames.settings;
    }
    if (path == RouteNames.prints) return RouteNames.prints;
    if (path == RouteNames.printsSheetsNew) {
      return _signedIn ? RouteNames.printsSheetsNew : RouteNames.settings;
    }
    if (path == RouteNames.printsPacksNew) {
      return _signedIn ? RouteNames.printsPacksNew : RouteNames.settings;
    }
    if (path == RouteNames.blobbers) return RouteNames.blobbers;
    if (path == RouteNames.search) return RouteNames.search;
    if (path == RouteNames.about) return RouteNames.about;
    if (path == RouteNames.terms) return RouteNames.terms;
    if (path == RouteNames.privacy) return RouteNames.privacy;
    if (path == RouteNames.upload) {
      return _signedIn ? RouteNames.upload : RouteNames.settings;
    }
    if (path == RouteNames.profile) return RouteNames.profile;
    if (path == RouteNames.favourites) return RouteNames.favourites;
    if (path == RouteNames.uploads) return RouteNames.uploads;
    if (path == RouteNames.profilePrints) return RouteNames.profilePrints;
    if (path == RouteNames.settings || path == '/settings') {
      return RouteNames.settings;
    }
    if (path == RouteNames.profileBlobber) return RouteNames.profileBlobber;
    if (path == RouteNames.profileBlobberAssociate) {
      return RouteNames.profileBlobberAssociate;
    }

    final stickersEdit = RegExp(r'^/stickers/([^/]+)/edit$');
    final stickersCompose = RegExp(r'^/stickers/([^/]+)/compose$');
    final stickersRemix = RegExp(r'^/stickers/([^/]+)/remix$');
    final stickersDetail = RegExp(r'^/stickers/([^/]+)$');
    final collectionsDetail = RegExp(r'^/collections/([^/]+)$');
    final sheetDetail = RegExp(r'^/prints/sheets/([^/]+)$');
    final packDetail = RegExp(r'^/prints/packs/([^/]+)$');
    final blobberId = RegExp(r'^/blobbers/id/([^/]+)$');
    final blobberSlug = RegExp(r'^/blobbers/([^/]+)$');

    var m = stickersEdit.firstMatch(path);
    if (m != null) {
      final loc = RouteNames.stickerEdit.replaceFirst(':slug', m[1]!);
      return _signedIn ? loc : RouteNames.sticker(m[1]!);
    }
    m = stickersCompose.firstMatch(path);
    if (m != null) {
      final loc = RouteNames.stickerCompose.replaceFirst(':slug', m[1]!);
      return _signedIn ? loc : RouteNames.sticker(m[1]!);
    }
    m = stickersRemix.firstMatch(path);
    if (m != null) {
      return RouteNames.stickerRemix.replaceFirst(':slug', m[1]!);
    }
    m = stickersDetail.firstMatch(path);
    if (m != null) return RouteNames.sticker(m[1]!);

    m = collectionsDetail.firstMatch(path);
    if (m != null) {
      if (m[1] == 'new') {
        return _signedIn ? RouteNames.collectionsNew : RouteNames.settings;
      }
      return RouteNames.collection(m[1]!);
    }

    m = sheetDetail.firstMatch(path);
    if (m != null) {
      if (m[1] == 'new') {
        return _signedIn ? RouteNames.printsSheetsNew : RouteNames.settings;
      }
      return RouteNames.sheet(m[1]!);
    }
    m = packDetail.firstMatch(path);
    if (m != null) {
      if (m[1] == 'new') {
        return _signedIn ? RouteNames.printsPacksNew : RouteNames.settings;
      }
      return RouteNames.pack(m[1]!);
    }

    m = blobberId.firstMatch(path);
    if (m != null) return RouteNames.blobberId(m[1]!);
    m = blobberSlug.firstMatch(path);
    if (m != null && m[1] != 'id') return RouteNames.blobber(m[1]!);

    return RouteNames.home;
  }

  static bool _isWebOnly(String path) {
    const prefixes = <String>[
      '/admin',
      '/profile/pending',
      '/profile/users',
      '/profile/claims',
      '/profile/workers',
      '/profile/prompts',
      '/profile/landing',
      '/profile/app-version',
      '/profile/logs',
      '/profile/history',
      '/profile/edits',
      '/profile/blobber-edits',
      '/profile/unlinked-blobbers',
      '/profile/blobber-associations',
    ];
    for (final p in prefixes) {
      if (path == p || path.startsWith('$p/')) return true;
    }
    // Admin blobber preview
    if (RegExp(r'^/blobbers/id/[^/]+/preview/').hasMatch(path)) return true;
    return false;
  }
}
