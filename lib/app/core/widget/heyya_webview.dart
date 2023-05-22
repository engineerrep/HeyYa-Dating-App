// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:heyya/config.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum HeyyaWebviewType {
  sa,
  pp,
}

extension ParseToString on HeyyaWebviewType {
  String toText() {
    switch (this) {
      case HeyyaWebviewType.pp:
        return "Privacy Policy";
      case HeyyaWebviewType.sa:
        return "Terms of Service";
    }
  }

  String toURL() {
    switch (this) {
      case HeyyaWebviewType.pp:
        return private_policy;
      case HeyyaWebviewType.sa:
        return terms_of_use;
    }
  }
}

class HeyyaWebview extends StatelessWidget {
  HeyyaWebviewType type;
  HeyyaWebview({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: WebView(
        initialUrl: type.toURL(),
        backgroundColor: const Color(0x00000000),
      ),
    ));
  }
}
