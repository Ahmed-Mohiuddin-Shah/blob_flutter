import 'package:flutter/widgets.dart';

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
}
