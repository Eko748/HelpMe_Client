import 'dart:convert';

class Order {
  int? id;
  String? category;
  String? problem;
  String? latitude;
  String? longitude;
  String? description;
  List<dynamic>? attachments;

  Order({
    this.id,
    this.category,
    this.problem,
    this.latitude,
    this.longitude,
    this.description,
    this.attachments,
  });

  factory Order.fromMap(Map<String, dynamic> data) => Order(
        id: data['id'] as int?,
        category: data['category'] as String?,
        problem: data['problem'] as String?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        description: data['description'] as String?,
        attachments: data['attachments'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'problem': problem,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'attachments': attachments,
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
