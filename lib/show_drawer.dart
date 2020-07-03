library show_drawer;

import 'package:flutter/widgets.dart';
import 'package:show_overlay/show_overlay.dart';

/// [_Builder] 包含三个参数，第一个为 [BuildContext], 第二个为 [Animation<double>]
/// 第三个为 [Function], 执行 [Function] 可以移除当前的 [Drawer]
typedef _Builder = Widget Function(BuildContext, Animation<double>, Function);

Function showDrawer({
  @required BuildContext context,

  /// [builder] 提供 builder 来构建你的 widget
  _Builder builder,

  /// 使用最根处的 [Overlay] 来展示
  bool useRootOverlay = true,

  /// [animationDuration] 如果你使用动画，可以通过这个指定动画的执行时间
  /// [animationCurve] 可以设置动画的 Curve 效果
  Duration animationDuration,
  Curve animationCurve = Curves.easeInOutCirc,

  /// [alignment] 指定动画的方向
  Alignment alignment,

  // 可以为你的 Overlay 添加一个位于背景的遮罩层
  /// [barrier] 设置为 false 则不使用 barrier
  /// [barrierBlur] 指定 barrier 的背景模糊效果
  /// [barrierColor] 为你的 barrier 指定背景颜色
  /// [barrierDismissible] 指定是否可以通过点击 barrier 移除本 [OverlayEntry]
  double barrierBlur,
  Color barrierColor,
  bool barrier = true,
  bool barrierDismissible = true,
}) {
  assert(builder != null);

  return showOverlay(
    barrier: true,
    context: context,
    barrierDismissible: true,
    useRootOverlay: useRootOverlay,
    animationDuration: animationDuration ?? Duration(milliseconds: 200),
    builder: (context, animation, closer) {
      return _AnimatedDrawer(
        curve: animationCurve,
        animation: animation,
        alignment: alignment,
        builder: builder,
        closer: closer,
      );
    },
  );
}

class _AnimatedDrawer extends AnimatedWidget {
  final Curve curve;
  final Function closer;
  final _Builder builder;
  final Alignment alignment;
  final Animation<double> animation;

  _AnimatedDrawer({
    Key key,
    this.curve,
    this.closer,
    this.builder,
    this.animation,
    this.alignment = Alignment.bottomCenter,
  }) : super(key: key, listenable: animation);

  Animation<Offset> get animationPosition {
    return Tween<Offset>(
      end: Offset(0.0, 0.0),
      begin: Offset(alignment.x, alignment.y),
    ).animate(
      animation.drive(
        CurveTween(
          curve: curve,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Align(
      alignment: this.alignment,
      child: SlideTransition(
        position: animationPosition,
        child: builder(context, animation, this.closer),
      ),
    );
  }
}
