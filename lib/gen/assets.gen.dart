// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// Directory path: assets/svgs/lucide
  $AssetsSvgsLucideGen get lucide => const $AssetsSvgsLucideGen();
}

class $AssetsSvgsLucideGen {
  const $AssetsSvgsLucideGen();

  /// File path: assets/svgs/lucide/heart.svg
  SvgGenImage get heart => const SvgGenImage('assets/svgs/lucide/heart.svg');

  /// File path: assets/svgs/lucide/image.svg
  SvgGenImage get image => const SvgGenImage('assets/svgs/lucide/image.svg');

  /// File path: assets/svgs/lucide/layers.svg
  SvgGenImage get layers => const SvgGenImage('assets/svgs/lucide/layers.svg');

  /// File path: assets/svgs/lucide/printer.svg
  SvgGenImage get printer =>
      const SvgGenImage('assets/svgs/lucide/printer.svg');

  /// File path: assets/svgs/lucide/search.svg
  SvgGenImage get search => const SvgGenImage('assets/svgs/lucide/search.svg');

  /// File path: assets/svgs/lucide/settings.svg
  SvgGenImage get settings =>
      const SvgGenImage('assets/svgs/lucide/settings.svg');

  /// File path: assets/svgs/lucide/sticky-note.svg
  SvgGenImage get stickyNote =>
      const SvgGenImage('assets/svgs/lucide/sticky-note.svg');

  /// File path: assets/svgs/lucide/user.svg
  SvgGenImage get user => const SvgGenImage('assets/svgs/lucide/user.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    heart,
    image,
    layers,
    printer,
    search,
    settings,
    stickyNote,
    user,
  ];
}

abstract final class Assets {
  static const String aEnv = '.env';
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
