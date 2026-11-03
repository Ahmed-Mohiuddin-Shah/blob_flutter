import 'package:blob_flutter/configs/routes/navigator_key.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/configs/utils/deeplinks/deep_link_mapper.dart';
import 'package:blob_flutter/configs/utils/xutils.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Stash App Link until splash finishes, then open.
abstract final class PendingDeepLink {
  static String? _path;
  static bool homeReady = false;

  static bool get hasPending => _path != null && _path!.isNotEmpty;

  static void setFromUri(Uri uri) {
    // Ignore AppAuth custom-scheme redirects — handled by flutter_appauth.
    if (_isOAuthRedirect(uri)) return;
    final loc = DeepLinkMapper.toAppLocation(uri);
    if (loc.isEmpty || loc == RouteNames.splash) return;
    _path = loc;
  }

  static void set(String location) {
    if (location.isEmpty || location == RouteNames.splash) return;
    _path = location;
  }

  static void clear() => _path = null;

  static bool _isOAuthRedirect(Uri uri) {
    final s = uri.scheme.toLowerCase();
    return s.startsWith('com.mamajees.blob.app');
  }

  /// Call when leaving splash for the main shell.
  /// Detail paths are pushed atop home so back returns to the shell.
  static void consumeAfterSplash(BuildContext context) {
    homeReady = true;
    final path = _path;
    _path = null;
    if (path == null || path.isEmpty) {
      context.go(RouteNames.home);
      return;
    }
    context.go(RouteNames.home);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = navigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      if (XUtils.isShellTab(path)) {
        ctx.go(path);
      } else {
        ctx.push(path);
      }
    });
  }
}
