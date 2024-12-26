import 'dart:convert';

class DetailOrderModel {
  int? orderId;
  String? orderStatus;
  String? orderTime;
  String? user;
  String? description;
  String? latitude;
  String? longitude;
  List<dynamic>? attachments;
  int? price;
  String? category;
  String? mitra;
  String? mitraProfile;
  String? phoneNumberMitra;
  bool? isRated;

  DetailOrderModel({
    this.orderId,
    this.orderStatus,
    this.orderTime,
    this.user,
    this.description,
    this.latitude,
    this.longitude,
    this.attachments,
    this.price,
    this.category,
    this.mitra,
    this.mitraProfile,
    this.phoneNumberMitra,
    this.isRated
  });

  factory DetailOrderModel.fromMap(Map<String, dynamic> data) {
    return DetailOrderModel(
      orderId: data['order_id'] as int?,
      orderStatus: data['order_status'] as String?,
      orderTime: data['order_time'] as String?,
      user: data['user'] as String?,
      description: data['description'] as String?,
      latitude: data['latitude'] as String?,
      longitude: data['longitude'] as String?,
      attachments: data['attachments'] as List<dynamic>?,
      price: data['price'] as int?,
      category: data['category'] as String?,
      mitra: data['mitra'] as String?,
      mitraProfile: data['mitra_profile'] as String?,
      phoneNumberMitra: data['phone_number_mitra'] as String?,
      isRated: data['is_rated'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'order_id': orderId,
        'order_status': orderStatus,
        'order_time': orderTime,
        'user': user,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'attachments': attachments,
        'price': price,
        'category': category,
        'mitra': mitra,
        'mitra_profile': mitraProfile,
        'phone_number_mitra': phoneNumberMitra,
        'is_rated': isRated,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DetailOrderModel].
  factory DetailOrderModel.fromJson(String data) {
    return DetailOrderModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DetailOrderModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
