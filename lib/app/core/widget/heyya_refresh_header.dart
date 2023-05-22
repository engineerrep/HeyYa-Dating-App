import 'dart:math';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeyyaRefreshHeader extends Header {
  final Key? key;
  final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();

  HeyyaRefreshHeader({
    this.key,
  }) : super(
          extent: 60.0,
          triggerDistance: 60.0,
          enableHapticFeedback: false,
          enableInfiniteRefresh: false,
          overScroll: false,
          completeDuration: const Duration(seconds: 1),
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    linkNotifier.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);

    return HeyyaRefreshHeaderWidget(key: key, linkNotifier: linkNotifier);
  }
}

class HeyyaRefreshHeaderWidget extends StatefulWidget {
  final LinkHeaderNotifier linkNotifier;

  const HeyyaRefreshHeaderWidget({Key? key, required this.linkNotifier})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HeyyaRefreshHeaderWidgetState();
  }
}

class _HeyyaRefreshHeaderWidgetState extends State<HeyyaRefreshHeaderWidget>
    with SingleTickerProviderStateMixin {
  RefreshMode get _refreshState => widget.linkNotifier.refreshState;

  double get _triggerDistance => widget.linkNotifier.refreshTriggerPullDistance;

  double get _pulledExtent => widget.linkNotifier.pulledExtent;

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _lottieAnimationBuilder(Animation<double>? controller) {
    return Lottie.asset(
      'assets/lottie/pull_to_refresh.json',
      controller: controller,
      width: 85.0,
      height: 45.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget lottieWidget;
    if (_refreshState == RefreshMode.armed ||
        _refreshState == RefreshMode.done ||
        _refreshState == RefreshMode.refresh ||
        _refreshState == RefreshMode.refreshed) {
      lottieWidget = _lottieAnimationBuilder(null);
    } else {
      _animationController.value =
          max(0.0, min(1.0, _pulledExtent / _triggerDistance));
      lottieWidget = _lottieAnimationBuilder(_animationController);
    }

    return Stack(
      children: [
        // Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: lottieWidget),
        Align(
          child: lottieWidget,
        )
      ],
    );
  }
}
