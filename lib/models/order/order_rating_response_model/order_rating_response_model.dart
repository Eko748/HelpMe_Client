import 'dart:convert';

import 'rating.dart';

class OrderRatingResponseModel {
  String? message;
  Rating? rating;

  OrderRatingResponseModel({this.message, this.rating});

  factory OrderRatingResponseModel.fromMap(Map<String, dynamic> data) {
    return OrderRatingResponseModel(
      message: data['message'] as String?,
      rating: data['rating'] == null
          ? null
          : Rating.fromMap(data['rating'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'rating': rating?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderRatingResponseModel].
  factory OrderRatingResponseModel.fromJson(String data) {
    return OrderRatingResponseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderRatingResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
