import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class AuthResponseModel {
  final String? message;
  final String? token;

  const AuthResponseModel({this.message, this.token});

  @override
  String toString() => 'AuthResponse(message: $message, token: $token)';

  factory AuthResponseModel.fromMap(Map<String, dynamic> data) =>
      AuthResponseModel(
        message: data['message'] as String?,
        token: data['token'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'token': token,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AuthResponseModel].
  factory AuthResponseModel.fromJson(String data) {
    return AuthResponseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AuthResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());

  AuthResponseModel copyWith({
    String? message,
    String? token,
  }) {
    return AuthResponseModel(
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }
}
