import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

Future<String?> deviceID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (GetPlatform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}
