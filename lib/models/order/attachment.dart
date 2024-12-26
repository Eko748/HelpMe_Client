import 'dart:convert';

import 'package:equatable/equatable.dart';

class Attachment extends Equatable {
  final String? imagePath;

  const Attachment({this.imagePath});

  factory Attachment.fromMap(Map<String, dynamic> data) => Attachment(
        imagePath: data['image_path'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'image_path': imagePath,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Attachment].
  factory Attachment.fromJson(String data) {
    return Attachment.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Attachment] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [imagePath];
}
