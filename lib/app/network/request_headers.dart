import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../data/local/Storage/storage.dart';

class RequestHeaderInterceptor extends InterceptorsWrapper {
  final HeyStorage _storage = Get.find<HeyStorage>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(getCustomHeaders());
    super.onRequest(options, handler);
  }

  Map<String, String> getCustomHeaders() {

    final String accessToken = _storage.getToken();
    var customHeaders = {'content-type': 'application/json'};
    if (accessToken.trim().isNotEmpty) {
      customHeaders.addAll({
        'X-TOKEN': accessToken,
      });
    }
    return customHeaders;
  }
}
