import 'package:get/get.dart';
import 'package:heyya/app/core/widget/heyya_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PpSaController extends GetxController {
  HeyyaWebviewType webviewType = HeyyaWebviewType.pp;

  @override
  void onInit() {
    super.onInit();
    webviewType = Get.arguments as HeyyaWebviewType;
    if (GetPlatform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
