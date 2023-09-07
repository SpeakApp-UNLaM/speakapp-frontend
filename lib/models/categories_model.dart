import 'package:sp_front/config/helpers/param.dart';

class CategoriesModel {
  Categories category;
  int level;

  CategoriesModel({
    required this.category,
    required this.level,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        category: Param.stringToEnumCategories(json["category"]),
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "level": level,
      };
}
