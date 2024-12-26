import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'attachment.dart';

class OrderModel extends Equatable {
  final int? id;
  final String? latitude;
  final String? longitude;
  final String? description;
  final List<Attachment>? attachments;

  const OrderModel({
    this.id,
    this.latitude,
    this.longitude,
    this.description,
    this.attachments,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data) => OrderModel(
        id: data['id'] as int?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        description: data['description'] as String?,
        attachments: (data['attachment'] as List<dynamic>?)
            ?.map((e) => Attachment.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'attachments': attachments,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderModel].
  factory OrderModel.fromJson(String data) {
    return OrderModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props {
    return [
      id,
      latitude,
      longitude,
      description,
      attachments,
    ];
  }
}
