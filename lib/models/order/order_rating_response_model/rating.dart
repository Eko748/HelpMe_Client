import 'dart:convert';

class Rating {
  int? rating;
  String? review;
  int? mitraId;
  int? userId;
  int? orderId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Rating({
    this.rating,
    this.review,
    this.mitraId,
    this.userId,
    this.orderId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Rating.fromMap(Map<String, dynamic> data) => Rating(
        rating: data['rating'] as int?,
        review: data['review'] as String?,
        mitraId: data['mitra_id'] as int?,
        userId: data['user_id'] as int?,
        orderId: data['order_id'] as int?,
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.parse(data['updated_at'] as String),
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
        id: data['id'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'rating': rating,
        'review': review,
        'mitra_id': mitraId,
        'user_id': userId,
        'order_id': orderId,
        'updated_at': updatedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Rating].
  factory Rating.fromJson(String data) {
    return Rating.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Rating] to a JSON string.
  String toJson() => json.encode(toMap());
}
