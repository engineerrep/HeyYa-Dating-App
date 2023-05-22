import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/core/base/response_list_entity.dart';

import 'package:heyya/app/network/exceptions/network_exception.dart';
import 'package:heyya/generated/json/response_entity.g.dart';

import '../../../generated/json/response_list_entity.g.dart';
import '/app/network/dio_provider.dart';
import '/app/network/error_handlers.dart';
import '/app/network/exceptions/base_exception.dart';
import '../../flavors/build_config.dart';

abstract class BaseRepository {
  Dio get dioClient => DioProvider.dioWithHeaderToken;

  final logger = BuildConfig.instance.config.logger;

  Future<ResponseEntity> callApiWithErrorParser(Future<Response> api) async {
    try {
      Response response = await api;

      if (response.statusCode != HttpStatus.ok ||
          (response.data as Map<String, dynamic>)['statusCode'] !=
              HttpStatus.ok) {
        var data = $ResponseEntityFromJson(response.data);
        if (data.code == 8200) {
          return data;
        }
        NetworkException exception = NetworkException(data.msg);
        throw exception;
      }
      NetworkException exception = NetworkException('Unknown error');
      throw exception;
    } on DioError catch (dioError) {
      Exception exception = handleDioError(dioError);
      logger.e(
          "Throwing error from repository: >>>>>>> $exception : ${(exception as BaseException).message}");
      throw exception;
    } catch (error) {
      logger.e("Generic error: >>>>>>> $error");

      if (error is BaseException) {
        rethrow;
      }

      throw handleError("$error");
    }
  }



  Future<ResponseListEntity> callListApiWithErrorParser(Future<Response> api) async {
    try {
      Response response = await api;

      if (response.statusCode != HttpStatus.ok ||
          (response.data as Map<String, dynamic>)['statusCode'] !=
              HttpStatus.ok) {

        var data = $ResponseListEntityFromJson(response.data);
        if (data.code == 8200) {
          return data;
        }
        NetworkException exception =NetworkException(data.msg);
        throw exception;
      }
      NetworkException exception =NetworkException('Unknown error');
      throw exception;

    } on DioError catch (dioError) {
      Exception exception = handleDioError(dioError);
      logger.e(
          "Throwing error from repository: >>>>>>> $exception : ${(exception as BaseException).message}");
      throw exception;
    } catch (error) {
      logger.e("Generic error: >>>>>>> $error");

      if (error is BaseException) {
        rethrow;
      }

      throw handleError("$error");
    }
  }
}
