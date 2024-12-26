import 'dart:convert';

class ChatResponseModel {
  int? senderId;
  String? message;
  DateTime? createdAt;

  ChatResponseModel({
    this.senderId,
    this.message,
    this.createdAt,
  });

  @override
  String toString() =>
      'ChatResponseModel(senderId: $senderId, message: $message, createdAt: $createdAt)';

  factory ChatResponseModel.fromMap(Map<String, dynamic> data) {
    return ChatResponseModel(
      senderId: data['sender_id'] as int?,
      message: data['message'] as String?,
      createdAt: data['created_at'] == null
          ? null
          : DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'sender_id': senderId,
        'message': message,
        'created_at': createdAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChatResponseModel].
  factory ChatResponseModel.fromJson(String data) {
    return ChatResponseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChatResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
