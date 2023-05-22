import 'dart:math';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeyyaRefreshFooter extends Footer {
  final Key? key;
  final LinkFooterNotifier linkNotifier = LinkFooterNotifier();

  HeyyaRefreshFooter({this.key})
      : super(
          extent: 60.0,
          triggerDistance: 60.0,
          enableHapticFeedback: false,
          enableInfiniteLoad: false,
          overScroll: false,
          completeDuration: const Duration(seconds: 1),
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    linkNotifier.contentBuilder(
        context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore);

    return HeyyaRefreshFooterWidget(linkNotifier: linkNotifier);
  }
}

class HeyyaRefreshFooterWidget extends StatefulWidget {
  final LinkFooterNotifier linkNotifier;

  const HeyyaRefreshFooterWidget({Key? key, required this.linkNotifier})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HeyyaRefreshFooterWidgetState();
  }
}

class _HeyyaRefreshFooterWidgetState extends State<HeyyaRefreshFooterWidget>
    with SingleTickerProviderStateMixin {
  LoadMode get _loadState => widget.linkNotifier.loadState;

  double get _triggerDistance => widget.linkNotifier.loadTriggerPullDistance;

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

  Widget _lottieWidget(Animation<double>? controller) {
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
    if (_loadState == LoadMode.armed ||
        _loadState == LoadMode.done ||
        _loadState == LoadMode.load ||
        _loadState == LoadMode.loaded) {
      lottieWidget = _lottieWidget(null);
    } else {
      _animationController.value =
          max(0.0, min(1.0, _pulledExtent / _triggerDistance));
      lottieWidget = _lottieWidget(_animationController);
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
