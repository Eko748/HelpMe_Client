import 'dart:convert';

class OfferModel {
  int? orderId;
  int? offerId;
  int? mitraId;
  String? mitraName;
  String? mitraProfile;
  String? price;
  int? estimatedTime;
  double? latitude;
  double? longitude;

  OfferModel({
    this.orderId,
    this.offerId,
    this.mitraId,
    this.mitraName,
    this.mitraProfile,
    this.price,
    this.estimatedTime,
    this.latitude,
    this.longitude,
  });

  factory OfferModel.fromMap(Map<String, dynamic> data) => OfferModel(
        orderId: data['order_id'] as int?,
        offerId: data['offer_id'] as int?,
        mitraId: data['mitra_id'] as int?,
        mitraName: data['mitra_name'] as String?,
        mitraProfile: data['mitra_profile'] as String?,
        price: data['price'] as String?,
        estimatedTime: data['estimated_time'] as int?,
        latitude: data['latitude'] as double?,
        longitude: data['longitude'] as double?,
      );

  Map<String, dynamic> toMap() => {
        'order_id': orderId,
        'offer_id': offerId,
        'mitra_id': mitraId,
        'mitra_name': mitraName,
        'mitra_profile': mitraProfile,
        'price': price,
        'estimated_time': estimatedTime,
        'latitude': latitude,
        'longitude': longitude,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OfferModel].
  factory OfferModel.fromJson(String data) {
    return OfferModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OfferModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
