import 'dart:convert';

import 'package:equatable/equatable.dart';

class OrderHistoryModel extends Equatable {
  final int? orderId;
  final String? orderStatus;
  final String? latitude;
  final String? longitude;
  final String? description;
  final String? orderTime;
  final String? user;
  final String? userProfile;
  final String? price;
  final String? category;
  final List<dynamic>? attachment;

  const OrderHistoryModel({
    this.orderId,
    this.orderStatus,
    this.latitude,
    this.longitude,
    this.description,
    this.orderTime,
    this.user,
    this.userProfile,
    this.price,
    this.category,
    this.attachment,
  });

  factory OrderHistoryModel.fromMap(Map<String, dynamic> data) =>
      OrderHistoryModel(
        orderId: (data['order_id'] ?? data['id']) as int?,
        orderStatus: data['order_status'] as String?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        description: data['description'] as String?,
        orderTime: data['order_time'] as String?,
        user: data['user'] as String?,
        userProfile: data['user_profile'] as String?,
        price: data['price'] as String?,
        category: data['problem'] as String?,
        attachment: (data['attachment'] as List<dynamic>?),
      );

  Map<String, dynamic> toMap() => {
        'order_id': orderId,
        'order_status': orderStatus,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'order_time': orderTime,
        'user': user,
        'user_profile': userProfile,
        'price': price,
        'category': category,
        'attachment': attachment,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderHistoryModel].
  factory OrderHistoryModel.fromJson(String data) {
    return OrderHistoryModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderHistoryModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props {
    return [
      orderId,
      orderStatus,
      latitude,
      longitude,
      description,
      orderTime,
      user,
      userProfile,
      price,
      category,
      attachment,
    ];
  }
}
