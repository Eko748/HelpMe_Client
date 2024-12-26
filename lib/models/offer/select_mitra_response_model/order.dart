import 'dart:convert';

class Order {
  int? orderId;
  String? price;
  String? latitude;
  String? longitude;
  String? mitra;
  String? mitraProfile;

  Order({
    this.orderId,
    this.price,
    this.latitude,
    this.longitude,
    this.mitra,
    this.mitraProfile,
  });

  factory Order.fromMap(Map<String, dynamic> data) => Order(
        orderId: data['order_id'] as int?,
        price: data['price'] as String?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        mitra: data['mitra'] as String?,
        mitraProfile: data['mitra_profile'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'order_id': orderId,
        'price': price,
        'latitude': latitude,
        'longitude': longitude,
        'mitra': mitra,
        'mitra_profile': mitraProfile,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Order].
  factory Order.fromJson(String data) {
    return Order.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Order] to a JSON string.
  String toJson() => json.encode(toMap());
}
