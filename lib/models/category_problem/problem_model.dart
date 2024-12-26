import 'dart:convert';

import 'package:equatable/equatable.dart';

class DataProblem {
  final List<ProblemModel> data;

  DataProblem({
    required this.data,
  });

  factory DataProblem.fromJson(Map<String, dynamic> json) => DataProblem(
        data: List<ProblemModel>.from(
          json['data'].map((problem) => ProblemModel.fromMap(problem)),
        ),
      );
}

class ProblemModel extends Equatable {
  final int? id;
  final String? name;
  final int? categoryId;

  const ProblemModel({this.id, this.name, this.categoryId});

  factory ProblemModel.fromMap(Map<String, dynamic> data) => ProblemModel(
        id: data['id'] as int?,
        name: data['name'] as String?,
        categoryId: data['category_id'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category_id': categoryId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProblemModel].
  factory ProblemModel.fromJson(String data) {
    return ProblemModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProblemModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ProblemModel copyWith({
    int? id,
    String? name,
    int? categoryId,
  }) {
    return ProblemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [id, name, categoryId];
}
