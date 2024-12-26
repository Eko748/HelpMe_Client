import 'package:dio/dio.dart';
import '../../models/api_error_response/message_error_model.dart';

class ApiException {
  Map<String, dynamic> apiException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return {
          'error': 'Connection timeout, try again after a few seconds',
        };
      case DioExceptionType.receiveTimeout:
        return {
          'error': 'Failed to receive data, try again after a few seconds',
        };
      case DioExceptionType.sendTimeout:
        return {
          'error': 'Failed to send data, try again after a few seconds',
        };
      case DioExceptionType.badCertificate:
        return {
          'error':
              'Failed to validate certificate, try again after a few seconds',
        };
      case DioExceptionType.badResponse:
        if (dioException.response?.statusCode == 400 ||
            dioException.response?.statusCode == 403 ||
            dioException.response?.statusCode == 405 ||
            dioException.response?.statusCode == 406 ||
            dioException.response?.statusCode == 408 ||
            dioException.response?.statusCode == 411 ||
            dioException.response?.statusCode == 415 ||
            dioException.response?.statusCode == 416 ||
            dioException.response?.statusCode == 422) {
          if (dioException.response?.data is Map<String, dynamic>) {
            final message = dioException.response?.data as Map<String, dynamic>;
            return message;
          } else {
            return {'error': dioException.response?.data as String};
          }
        } else if (dioException.response?.statusCode == 401) {
          return {'error': 'Unauthorized'};
        } else {
          return {
            'error': 'Failed to process data, try again after a few seconds',
          };
        }
      case DioExceptionType.cancel:
        return {
          'error':
              'Network request was cancelled, try again after a few seconds',
        };
      case DioExceptionType.connectionError:
        return {
          'error': 'Connection error, try again after a few seconds',
        };
      case DioExceptionType.unknown:
        return {
          'error': 'An error occurred, try again after a few seconds',
        };
    }
  }

  static String errorMessageBuilder(MessageErrorModel errorModel) {
    String errorMessage = ' ';
    if (errorModel.error != null) {
      errorMessage += '${errorModel.error}\n';
    }
    if (errorModel.message != null) {
      errorMessage += '${errorModel.message}\n';
    }
    if (errorModel.fullname != null) {
      errorMessage += '${errorModel.fullname}\n';
    }
    if (errorModel.username != null) {
      errorMessage += '${errorModel.username}\n';
    }
    if (errorModel.phoneNumber != null) {
      errorMessage += '${errorModel.phoneNumber}\n';
    }
    if (errorModel.password != null) {
      errorMessage += '${errorModel.password}\n';
    }
    if (errorModel.role != null) {
      errorMessage += '${errorModel.role}\n';
    }
    if (errorModel.newPassword != null) {
      errorMessage += '${errorModel.newPassword}\n';
    }
    if (errorModel.verificationCode != null) {
      errorMessage += '${errorModel.verificationCode}\n';
    }
    errorMessage = errorMessage.trim();
    return errorMessage;
  }
}
