import 'package:get/get.dart';
import 'package:heyya/app/data/local/Storage/storage.dart';

class LaunchController extends GetxController {
  final HeyStorage _storage = Get.find<HeyStorage>();
  bool isSignIn = false;

  @override
  void onInit() {
    super.onInit();

    var token = _storage.getToken();
    var imSig = _storage.getSig();
    var user = _storage.getUser();

    if (token.isNotEmpty && imSig.isNotEmpty) {
      isSignIn = true;
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
