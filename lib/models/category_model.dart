import 'package:sp_front/config/helpers/param.dart';

import '../domain/entities/category.dart';

class CategoryModel {
  Categories category;
  int level;
  int idTask;

  CategoryModel(
      {required this.category, required this.level, required this.idTask});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        category: Param.stringToEnumCategories(json["category"]),
        level: json["level"],
        idTask: json["idTask"],
      );

  Map<String, dynamic> toJson() =>
      {"category": category, "level": level, "idTask": idTask};

  Category toCategoryEntity() =>
      Category(category: category, level: level, idTask: idTask);
}
