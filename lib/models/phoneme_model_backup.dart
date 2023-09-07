// To parse this JSON data, do
//
//     final phonemeModel = phonemeModelFromJson(jsonString);

import 'dart:convert';

import 'package:sp_front/presentations/widgets/button_phoneme.dart';

import '../config/helpers/param.dart';
import '../domain/entities/level.dart';
import 'categories_model.dart';

List<PhonemeModel> phonemeModelFromJson(String str) => List<PhonemeModel>.from(
    json.decode(str).map((x) => PhonemeModel.fromJson(x)));

String phonemeModelToJson(List<PhonemeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhonemeModel {
  Phoneme phoneme;
  List<CategoriesModel> categoriesModel;

  PhonemeModel({
    required this.phoneme,
    required this.categoriesModel,
  });

  factory PhonemeModel.fromJson(Map<String, dynamic> json) => PhonemeModel(
        phoneme: Phoneme.fromJson(json["phoneme"]),
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

class Phoneme {
  int idPhoneme;
  String namePhoneme;

  Phoneme({
    required this.idPhoneme,
    required this.namePhoneme,
  });

  factory Phoneme.fromJson(Map<String, dynamic> json) => Phoneme(
        idPhoneme: json["idPhoneme"],
        namePhoneme: json["namePhoneme"],
      );

  Map<String, dynamic> toJson() => {
        "idPhoneme": idPhoneme,
        "namePhoneme": namePhoneme,
      };
}
