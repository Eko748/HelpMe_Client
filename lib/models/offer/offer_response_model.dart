import 'dart:convert';

import 'offer_model.dart';

class OfferResponseModel {
  List<OfferModel>? data;

  OfferResponseModel({this.data});

  factory OfferResponseModel.fromMap(Map<String, dynamic> data) =>
      OfferResponseModel(
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => OfferModel.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OfferResponseModel].
  factory OfferResponseModel.fromJson(String data) {
    return OfferResponseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OfferResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
