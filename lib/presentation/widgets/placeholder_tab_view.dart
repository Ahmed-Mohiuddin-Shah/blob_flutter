import 'package:blob_flutter/configs/app/global/app_colors.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaceholderTabView extends StatelessWidget {
  const PlaceholderTabView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.push(RouteNames.settings),
            icon: Assets.svgs.lucide.settings.svg(
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppColors.inactiveLight,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toLowerCase(),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w300,
                color: AppColors.foregroundLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.secondaryLight),
            ),
          ],
        ),
      ),
    );
  }
}
