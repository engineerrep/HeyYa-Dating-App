import 'package:flutter/material.dart';

import 'common_background.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  const CustomScaffold(
      {super.key,
      this.appBar,
      required this.body,
      this.extendBodyBehindAppBar = true,
      this.resizeToAvoidBottomInset = true});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        appBar: appBar,
        body: GestureDetector(
            child: body,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            }));
  }
}

class CustomScaffoldWithBackground extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  const CustomScaffoldWithBackground(
      {super.key, this.appBar, required this.body});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          CommonBackground(),
          body,
        ],
      ),
    );
  }
}
