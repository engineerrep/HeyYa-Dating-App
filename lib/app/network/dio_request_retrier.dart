import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../data/local/Storage/storage.dart';
import '/app/network/dio_provider.dart';

class DioRequestRetrier {
  final dioClient = DioProvider.tokenClient;
  final RequestOptions requestOptions;

  final HeyStorage _storage = getx.Get.find<HeyStorage>();

  DioRequestRetrier({required this.requestOptions});

  Future<Response<T>> retry<T>() async {
    var header = getCustomHeaders();

    return await dioClient.request(
      requestOptions.path,
      cancelToken: requestOptions.cancelToken,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      options: Options(headers: header, method: requestOptions.method),
    );
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
