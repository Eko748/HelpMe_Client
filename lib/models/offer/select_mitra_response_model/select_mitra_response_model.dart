import 'dart:convert';

import 'order.dart';

class SelectMitraResponseModel {
  String? message;
  Order? order;

  SelectMitraResponseModel({this.message, this.order});

  factory SelectMitraResponseModel.fromMap(Map<String, dynamic> data) {
    return SelectMitraResponseModel(
      message: data['message'] as String?,
      order: data['order'] == null
          ? null
          : Order.fromMap(data['order'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'order': order?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SelectMitraResponseModel].
  factory SelectMitraResponseModel.fromJson(String data) {
    return SelectMitraResponseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SelectMitraResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
