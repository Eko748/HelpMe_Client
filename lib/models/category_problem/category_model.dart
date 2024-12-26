class DataCategory {
  final List<CategoryModel> data;

  DataCategory({
    required this.data,
  });

  factory DataCategory.fromJson(Map<String, dynamic> json) => DataCategory(
        data: List<CategoryModel>.from(
          json['data'].map(
            (category) => CategoryModel.fromModel(category),
          ),
        ),
      );
}

class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromModel(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
      );
}
