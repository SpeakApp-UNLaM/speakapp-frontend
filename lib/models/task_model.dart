import 'dart:convert';

import 'package:sp_front/models/phoneme.dart';
import 'package:sp_front/presentations/widgets/button_phoneme.dart';

import '../config/helpers/param.dart';
import '../domain/entities/level.dart';
import 'categories_model.dart';

List<TaskModel> taskModelFromJson(String str) =>
    List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String taskModelToJson(List<TaskModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskModel {
  PhonemeModel phoneme;
  List<CategoriesModel> categoriesModel;

  TaskModel({
    required this.phoneme,
    required this.categoriesModel,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        phoneme: PhonemeModel.fromJson(json["phoneme"]),
        categoriesModel: List<CategoriesModel>.from(
            json["categoriesDTO"].map((x) => CategoriesModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "phoneme": phoneme.toJson(),
        "categoriesDTO":
            List<dynamic>.from(categoriesModel.map((x) => x.toJson())),
      };

  ButtonPhoneme toButtonPhonemeEntity() {
    return ButtonPhoneme(
      idPhoneme: phoneme.idPhoneme,
      namePhoneme: phoneme.namePhoneme,
      levels: createLevels(categoriesModel),
      tag: phoneme.idPhoneme.toString(),
    );
  }

  List<Level> createLevels(List<CategoriesModel> categoriesDto) {
    final nivelMap = <int, List<Categories>>{};

    for (final item in categoriesDto) {
      final categoryModel = item;
      nivelMap
          .putIfAbsent(categoryModel.level, () => [])
          .add(categoryModel.category);
    }

    return nivelMap.entries.map((entry) {
      return Level(value: entry.key, categories: entry.value);
    }).toList();
  }
}
