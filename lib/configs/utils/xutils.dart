import 'package:blob_flutter/configs/app/enums/enums.dart';
import 'package:blob_flutter/configs/app/global/app_colors.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/configs/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class XUtils {
  const XUtils._();

  static Size getScreenSize(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    if (mq != null) return mq.size;
    final view = View.maybeOf(context);
    return view == null ? Size.zero : view.physicalSize / view.devicePixelRatio;
  }

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  static EdgeInsets getScreenPadding(BuildContext context) {
    return MediaQuery.paddingOf(context);
  }

  static bool isShellTab(String routeName) {
    final path = routeName.split('?').first;
    return path == RouteNames.stickers ||
        path == RouteNames.blobbers ||
        path == RouteNames.prints ||
        path == RouteNames.collections ||
        path == RouteNames.search ||
        path.startsWith('${RouteNames.search}?');
  }

  static Future<void> launchURL(String url) async {
    try {
      final trimmed = url.trim();
      final Uri uri = trimmed.contains('://')
          ? Uri.parse(trimmed)
          : Uri.parse('https://$trimmed');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        appLog.warning('Could not launch $trimmed');
      }
    } catch (e) {
      appLog.severe('Exception caught in launchURL(): $e');
    }
  }

  static Future<void> launchGoogleMaps(
    double latitude,
    double longitude,
  ) async {
    try {
      final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
      await launchURL(uri.toString());
    } catch (e) {
      appLog.severe('Exception caught in launchGoogleMaps(): $e');
    }
  }

  static Future<void> launchEmail({
    String? scheme,
    String? path,
    String? subject,
    String? body,
  }) async {
    try {
      String query = '';
      if (subject != null) {
        query += 'subject=${Uri.encodeComponent(subject)}';
      }
      if (body != null) {
        if (query.isNotEmpty) query += '&';
        query += 'body=${Uri.encodeComponent(body)}';
      }

      final Uri emailUri = Uri(
        scheme: scheme ?? 'mailto',
        path: path,
        query: query.isNotEmpty ? query : null,
      );
      // Skip canLaunchUrl — Android 11+ often returns false for mailto.
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) appLog.warning('Could not launch $emailUri');
    } catch (e) {
      appLog.severe('Exception caught in launchEmail(): $e');
    }
  }

  static Future<void> launchPhoneCall({required String phoneNumber}) async {
    if (phoneNumber == 'N/A' || phoneNumber.isEmpty) {
      appLog.warning('Phone number is not available');
      return;
    }

    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      appLog.severe('Exception caught in launchPhoneCall(): $e');
    }
  }

  static Future<void> launchWhatsApp({required String phoneNumber}) async {
    if (phoneNumber == 'N/A' || phoneNumber.isEmpty) {
      appLog.warning('WhatsApp number is not available');
      return;
    }

    try {
      final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
      }
    } catch (e) {
      appLog.severe('Exception caught in launchWhatsApp(): $e');
    }
  }

  static void showSnackBar(
    BuildContext context,
    String text, {
    Color? bgColor,
    IconData? icon,
    String? svgIcon,
    double? iconSize,
    String? buttonText,
    TextStyle? textStyle,
    VoidCallback? onButtonPress,
    Color? iconColor,
    SnackbarType snackbarType = SnackbarType.success,
  }) {
    try {
      final backgroundColor =
          bgColor ??
          (snackbarType == SnackbarType.success
              ? AppColors.success
              : AppColors.error);

      final ScaffoldMessengerState? scaffoldMessenger =
          ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger == null) {
        appLog.warning('ScaffoldMessenger not available in context');
        return;
      }
      final Size size = getScreenSize(context);
      final theme = Theme.of(context);
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1500),
          backgroundColor: backgroundColor,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? AppColors.accentPink,
                  size: iconSize ?? 18,
                ),
                SizedBox(width: size.width * 0.015),
              ],
              if (svgIcon != null) ...[
                SvgPicture.asset(
                  svgIcon,
                  width: iconSize ?? 18,
                  height: iconSize ?? 18,
                  colorFilter: iconColor != null
                      ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                      : null,
                ),
                SizedBox(width: size.width * 0.015),
              ],
              Expanded(
                child: Text(
                  text,
                  style:
                      textStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.foregroundDark,
                      ),
                  textAlign: (icon != null && buttonText != null)
                      ? null
                      : TextAlign.center,
                ),
              ),
              if (onButtonPress != null)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.height * 0.005,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: onButtonPress,
                  child: Text(
                    buttonText ?? '',
                    style: theme.textTheme.labelLarge?.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.accentPink,
                      decorationThickness: 2,
                      color: AppColors.accentPink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      appLog.severe('Failed to show snackbar: $e');
    }
  }

  static void safePop<T>(BuildContext context, {T? returnValue}) {
    if (!context.mounted) return;
    if (Navigator.maybeOf(context) != null && Navigator.canPop(context)) {
      if (returnValue != null) {
        Navigator.of(context).pop(returnValue);
      } else {
        Navigator.of(context).pop();
      }
      return;
    }
    context.go(RouteNames.home);
  }

  /// Shell tabs use `go`; everything else uses `push` / `pushOrPopTo`.
  static void openAppPath(BuildContext context, String routeName) {
    if (isShellTab(routeName) || routeName == RouteNames.home) {
      context.go(routeName);
    } else {
      context.pushOrPopTo(routeName);
    }
  }

  /// https → browser; otherwise in-app path.
  static void openRedirect(BuildContext context, {String? path, String? url}) {
    final external = url?.trim();
    if (external != null && external.isNotEmpty) {
      launchURL(external);
      return;
    }
    final inApp = path?.trim();
    if (inApp != null && inApp.isNotEmpty) openAppPath(context, inApp);
  }

  static Future<void> lockOrientationToPortrait() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static Future<void> lockOrientationToLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  static String wrapWithLTRUnicode(String text) => '\u2066$text\u2069';
}

extension PushOrPopTo on BuildContext {
  /// Pops back to [location] if that page is already under us; otherwise pushes.
  void pushOrPopTo(String location, {Object? extra}) {
    try {
      if (!_stackHas(location)) {
        push(location, extra: extra);
        return;
      }
      do {
        pop();
      } while (canPop() && !_isCurrent(location));
    } catch (e) {
      appLog.severe('Exception caught in pushOrPopTo(): $e');
    }
  }

  bool _stackHas(String location) {
    final matches = GoRouter.of(
      this,
    ).routerDelegate.currentConfiguration.matches;
    return matches
        .take(matches.length - 1)
        .any((match) => _isRoute(match, location));
  }

  bool _isCurrent(String location) {
    final matches = GoRouter.of(
      this,
    ).routerDelegate.currentConfiguration.matches;
    return matches.isNotEmpty && _isRoute(matches.last, location);
  }

  // Concrete uri path — works for static and REST (`/stickers/:id` → `/stickers/abc`).
  bool _isRoute(RouteMatchBase match, String location) =>
      match is ImperativeRouteMatch && match.matches.uri.path == location;
}
