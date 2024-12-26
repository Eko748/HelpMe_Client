import 'package:dio/dio.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../services/api/api_exception.dart';

class ApiController {
    static const baseUrl = 'http://192.168.8.77:8000';
  // static const baseUrl = 'http://103.49.239.32';
  static String? token;

  static var dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/api/v1/',
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ),
  );

  static Map<String, dynamic> checkException(DioException error) {
    ApiException exception = ApiException();
    return exception.apiException(error);
  }

  static Future getData(String url) async {
    try {
      final response = await dio.get(
        url,
        options: token != null
            ? Options(
                headers: {'Authorization': 'Bearer $token'},
              )
            : null,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } on DioException catch (e) {
      final error = checkException(e);
      return ApiErrorResponseModel.fromMap(error);
    } catch (e) {
      throw Exception(e);
    }
  }

  /* 
    extra header untuk request yang membutuhkan multipart form data
  */
  static Future postData(
    String url, [
    dynamic data,
    String? extraHeaders,
  ]) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        options: token != null
            ? Options(
                headers: {'Authorization': 'Bearer $token'},
                contentType: extraHeaders ?? Headers.jsonContentType,
              )
            : null,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return response.data;
      } else {
        throw Exception('Failed to post data');
      }
    } on DioException catch (e) {
      final error = checkException(e);
      return ApiErrorResponseModel.fromMap(error);
    } catch (e) {
      throw Exception(e);
    }
  }
}
