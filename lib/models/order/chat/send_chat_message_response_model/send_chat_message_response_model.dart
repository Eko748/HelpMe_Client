import 'dart:convert';

import 'data.dart';

class SendChatMessageResponseModel {
  String? message;
  Data? data;

  SendChatMessageResponseModel({this.message, this.data});

  factory SendChatMessageResponseModel.fromMap(Map<String, dynamic> data) {
    return SendChatMessageResponseModel(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SendChatMessageResponseModel].
  factory SendChatMessageResponseModel.fromJson(String data) {
    return SendChatMessageResponseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SendChatMessageResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
