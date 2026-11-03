import 'package:blob_flutter/configs/app/global/app_colors.dart';
import 'package:blob_flutter/configs/utils/xutils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Dark rounded bubble [Tooltip] with a caret that tracks the trigger.
class CustomTooltip extends StatelessWidget {
  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = true,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.verticalOffset,
  });

  final String message;
  final Widget child;
  final bool preferBelow;
  final TooltipTriggerMode triggerMode;
  final double? verticalOffset;
  static const _fill = AppColors.backgroundDark;

  @override
  Widget build(BuildContext context) {
    final size = XUtils.getScreenSize(context);
    final arrowH = size.height * 0.007;
    final arrowW = size.width * 0.03;
    // Shared with [positionDelegate] so [_BubbleDecoration] can place the caret.
    final caret = _CaretAnchor();
    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      triggerMode: triggerMode,
      constraints: BoxConstraints(maxWidth: size.width * 0.5),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.01,
      ),
      verticalOffset: verticalOffset,
      showDuration: const Duration(milliseconds: 3500),
      positionDelegate: (ctx) {
        final offset = positionDependentBox(
          size: ctx.overlaySize,
          childSize: ctx.tooltipSize,
          target: ctx.target,
          verticalOffset: ctx.verticalOffset,
          preferBelow: ctx.preferBelow,
        );
        caret.targetCenterX = ctx.target.dx;
        caret.popoverLeft = offset.dx;
        // Tooltip is below the target when its top edge is at/under the target.
        caret.belowTarget = offset.dy >= ctx.target.dy;
        caret.ready = true;
        return offset;
      },
      decoration: _BubbleDecoration(
        color: _fill,
        radius: size.width * 0.025,
        arrowWidth: arrowW,
        arrowHeight: arrowH,
        caret: caret,
      ),
      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.foregroundDark,
        fontWeight: FontWeight.w400,
      ),
      child: child,
    );
  }
}

class _CaretAnchor {
  bool ready = false;
  bool belowTarget = true;
  double targetCenterX = 0;
  double popoverLeft = 0;
}

/// Bubble + caret painted every frame from [caret] (no ShapeDecoration path cache).
class _BubbleDecoration extends Decoration {
  const _BubbleDecoration({
    required this.color,
    required this.radius,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.caret,
  });

  final Color color;
  final double radius;
  final double arrowWidth;
  final double arrowHeight;
  final _CaretAnchor caret;

  // Reserve both edges so size is correct before side is known in positionDelegate.
  @override
  EdgeInsetsGeometry get padding => EdgeInsets.symmetric(vertical: arrowHeight);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BubblePainter(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _BubbleDecoration &&
            other.color == color &&
            other.radius == radius &&
            other.arrowWidth == arrowWidth &&
            other.arrowHeight == arrowHeight &&
            identical(other.caret, caret);
  }

  @override
  int get hashCode => Object.hash(
    color,
    radius,
    arrowWidth,
    arrowHeight,
    identityHashCode(caret),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('radius', radius))
      ..add(DoubleProperty('arrowWidth', arrowWidth))
      ..add(DoubleProperty('arrowHeight', arrowHeight));
  }
}

class _BubblePainter extends BoxPainter {
  _BubblePainter(this.decoration);

  final _BubbleDecoration decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    final rect = offset & size;
    final path = _pathFor(rect);
    canvas.drawPath(path, Paint()..color = decoration.color);
  }

  Path _pathFor(Rect rect) {
    final arrowH = decoration.arrowHeight;
    final arrowW = decoration.arrowWidth;
    final body = Rect.fromLTRB(
      rect.left,
      rect.top + arrowH,
      rect.right,
      rect.bottom - arrowH,
    );
    final caret = decoration.caret;
    final double cx;
    if (caret.ready) {
      final inset = rect.width * 0.04;
      final max = rect.width - arrowW - inset;
      final caretLeft = max < inset
          ? (rect.width - arrowW) / 2
          : (caret.targetCenterX - caret.popoverLeft - arrowW / 2).clamp(
              inset,
              max,
            );
      cx = rect.left + caretLeft + arrowW / 2;
    } else {
      cx = rect.center.dx;
    }

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(body, Radius.circular(decoration.radius)),
      );
    if (caret.ready ? caret.belowTarget : true) {
      // Caret on top, tip pointing up toward target above.
      path
        ..moveTo(cx - arrowW / 2, body.top)
        ..lineTo(cx, rect.top)
        ..lineTo(cx + arrowW / 2, body.top)
        ..close();
    } else {
      // Caret on bottom, tip pointing down toward target below.
      path
        ..moveTo(cx - arrowW / 2, body.bottom)
        ..lineTo(cx, rect.bottom)
        ..lineTo(cx + arrowW / 2, body.bottom)
        ..close();
    }
    return path;
  }
}
