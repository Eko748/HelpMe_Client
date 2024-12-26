import 'dart:convert';

class Data {
  int? senderId;
  String? message;
  DateTime? createdAt;

  Data({this.senderId, this.message, this.createdAt});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        senderId: data['sender_id'] as int?,
        message: data['message'] as String?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'sender_id': senderId,
        'message': message,
        'created_at': createdAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
