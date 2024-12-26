import 'package:flutter/foundation.dart';

import 'message_error_model.dart';

@immutable
class ApiErrorResponseModel {
  final MessageErrorModel? error;

  const ApiErrorResponseModel({this.error});

  @override
  String toString() => '$error';

  factory ApiErrorResponseModel.fromMap(Map<String, dynamic> data) {
    if (data.containsKey('error')) {
      final value = data['error'];
      if (value is String) {
        return ApiErrorResponseModel(
          error: MessageErrorModel(error: value),
        );
      } else {
        return ApiErrorResponseModel(
          error: MessageErrorModel.fromMap(data['error']),
        );
      }
    } else if (data.containsKey('message')) {
      final value = data['message'];
      if (value is String) {
        return ApiErrorResponseModel(
          error: MessageErrorModel(message: value),
        );
      } else {
        return ApiErrorResponseModel(error: MessageErrorModel.fromMap(value));
      }
    } else {
      return const ApiErrorResponseModel(
        error: MessageErrorModel(error: 'Unknown error'),
      );
    }
  }
}
