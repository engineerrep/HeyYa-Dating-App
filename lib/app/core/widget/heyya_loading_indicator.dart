import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeyyaLoadingIndicator extends StatelessWidget {
  const HeyyaLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Lottie.asset(
        'assets/lottie/page_loading.json',
        width: 150.0,
        height: 100.0,
      ),
    ));
  }
}

VoidCallback showLoading() {
  return BotToast.showCustomLoading(
    backgroundColor: Colors.transparent,
    toastBuilder: (_) => const HeyyaLoadingIndicator(),
  );
}
