import 'dart:ui';

import 'package:blob_flutter/configs/app/global/app_colors.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Translucent glass bar. Content scrolls underneath; uses MediaQuery padding
/// (never SafeArea).
class GlassAppBar extends StatelessWidget {
  const GlassAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showSettings = true,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showSettings;

  static double heightOf(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return top + 56;
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = isDark
        ? Colors.black.withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.55);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: top),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  if (leading != null)
                    leading!
                  else if (Navigator.of(context).canPop())
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                    )
                  else
                    const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w300, height: 1.05),
                    ),
                  ),
                  ...?actions,
                  if (showSettings)
                    IconButton(
                      tooltip: 'Settings',
                      onPressed: () => context.push(RouteNames.settings),
                      icon: Assets.svgs.lucide.settings.svg(
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          isDark
                              ? AppColors.inactiveDark
                              : AppColors.inactiveLight,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
