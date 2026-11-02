import 'package:blob_flutter/configs/app/global/app_colors.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/configs/utils/xutils.dart';
import 'package:blob_flutter/data/repositories/preferences/shared_prefs.dart';
import 'package:blob_flutter/gen/assets.gen.dart';
import 'package:blob_flutter/logic/app_settings/app_settings_cubit.dart';
import 'package:blob_flutter/logic/home/home_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdaptiveNavShell extends StatelessWidget {
  const AdaptiveNavShell({super.key, required this.child});

  final Widget child;

  static const _tabs = <({HomeTab tab, String route, String label})>[
    (tab: HomeTab.stickers, route: RouteNames.stickers, label: 'Stickers'),
    (tab: HomeTab.blobbers, route: RouteNames.blobbers, label: 'Blobbers'),
    (tab: HomeTab.prints, route: RouteNames.prints, label: 'Prints'),
    (
      tab: HomeTab.collections,
      route: RouteNames.collections,
      label: 'Collections',
    ),
    (tab: HomeTab.search, route: RouteNames.search, label: 'Search'),
  ];

  static SvgGenImage _icon(HomeTab tab) => switch (tab) {
        HomeTab.stickers => Assets.svgs.lucide.stickyNote,
        HomeTab.blobbers => Assets.svgs.lucide.user,
        HomeTab.prints => Assets.svgs.lucide.printer,
        HomeTab.collections => Assets.svgs.lucide.layers,
        HomeTab.search => Assets.svgs.lucide.search,
      };

  static int indexForLocation(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      final route = _tabs[i].route;
      if (location == route || location.startsWith('$route/')) return i;
    }
    return 0;
  }

  void _onSelect(BuildContext context, int index) {
    context.read<HomeNavigationCubit>().selectTab(index);
    context.go(_tabs[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final landscape = XUtils.isLandscape(context);
    // Derive from route — never mutate Cubit inside pageBuilder (duplicate keys).
    final location = GoRouterState.of(context).matchedLocation;
    final index = indexForLocation(location);

    if (!landscape) {
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => _onSelect(context, i),
          destinations: [
            for (final t in _tabs)
              NavigationDestination(
                icon: _NavIcon(asset: _icon(t.tab)),
                selectedIcon: _NavIcon(asset: _icon(t.tab), selected: true),
                label: t.label,
              ),
          ],
        ),
      );
    }

    return BlocSelector<AppSettingsCubit, AppSettingsState, NavRailSide>(
      selector: (s) => s.navRailSide,
      builder: (context, side) {
        final rail = NavigationRail(
          selectedIndex: index,
          onDestinationSelected: (i) => _onSelect(context, i),
          labelType: NavigationRailLabelType.all,
          destinations: [
            for (final t in _tabs)
              NavigationRailDestination(
                icon: _NavIcon(asset: _icon(t.tab)),
                selectedIcon: _NavIcon(asset: _icon(t.tab), selected: true),
                label: Text(t.label),
              ),
          ],
        );

        return Scaffold(
          body: Row(
            children: [
              if (side == NavRailSide.left) rail,
              Expanded(child: child),
              if (side == NavRailSide.right) rail,
            ],
          ),
        );
      },
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.asset, this.selected = false});

  final SvgGenImage asset;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accentPink : AppColors.inactiveLight;
    return asset.svg(
      width: 22,
      height: 22,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
