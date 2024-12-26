import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class OrderRequestModel extends Equatable {
  final int? problemId;
  final String? description;
  final List<MultipartFile?>? attachments;
  final double lat;
  final double long;

  const OrderRequestModel({
    this.problemId,
    this.description,
    this.attachments,
    required this.lat,
    required this.long,
  });

  factory OrderRequestModel.fromMap(Map<String, dynamic> data) =>
      OrderRequestModel(
        problemId: data['problem_id'] as int?,
        description: data['description'] as String?,
        attachments: data['attachments'] as List<MultipartFile?>?,
        lat: data['latitude'] as double,
        long: data['longitude'] as double,
      );

  Map<String, dynamic> toMap() => {
        'problem_id': problemId,
        'description': description,
        'attachments[]': attachments,
        'latitude': lat,
        'longitude': long,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderRequestModel].
  factory OrderRequestModel.fromJson(String data) {
    return OrderRequestModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderRequestModel] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderRequestModel copyWith({
    int? problemId,
    String? description,
    List<MultipartFile?>? attachments,
    double? lat,
    double? long,
  }) {
    return OrderRequestModel(
      problemId: problemId ?? this.problemId,
      description: description ?? this.description,
      attachments: attachments ?? this.attachments,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  @override
  List<Object?> get props => [
        problemId,
        description,
        attachments,
        lat,
        long,
      ];
}
