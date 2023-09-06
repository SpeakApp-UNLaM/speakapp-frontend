// To parse this JSON data, do
//
//     final phonemeModel = phonemeModelFromJson(jsonString);

import 'dart:convert';

import 'package:sp_front/presentations/widgets/button_phoneme.dart';

import '../domain/entities/level.dart';

List<PhonemeModel> phonemeModelFromJson(String str) => List<PhonemeModel>.from(
    json.decode(str).map((x) => PhonemeModel.fromJson(x)));

String phonemeModelToJson(List<PhonemeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhonemeModel {
  Phoneme phoneme;
  List<CategoriesDto> categoriesDto;

  PhonemeModel({
    required this.phoneme,
    required this.categoriesDto,
  });

  factory PhonemeModel.fromJson(Map<String, dynamic> json) => PhonemeModel(
        phoneme: Phoneme.fromJson(json["phoneme"]),
        categoriesDto: List<CategoriesDto>.from(
            json["categoriesDTO"].map((x) => CategoriesDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "phoneme": phoneme.toJson(),
        "categoriesDTO":
            List<dynamic>.from(categoriesDto.map((x) => x.toJson())),
      };

  ButtonPhoneme toButtonPhonemeEntity() {
    return ButtonPhoneme(
      idPhoneme: phoneme.idPhoneme,
      namePhoneme: phoneme.namePhoneme,
      levels: createLevels(categoriesDto),
      tag: phoneme.idPhoneme.toString(),
    );
  }

  List<Level> createLevels(List<CategoriesDto> categoriesDto) {
    final nivelMap = <int, List<String>>{};

    for (final item in categoriesDto) {
      final categoryDTO = item;
      nivelMap
          .putIfAbsent(categoryDTO.level, () => [])
          .add(categoryDTO.category);
    }

    return nivelMap.entries.map((entry) {
      return Level(name: '${entry.key}', categories: entry.value);
    }).toList();
  }
}

class CategoriesDto {
  String category;
  int level;

  CategoriesDto({
    required this.category,
    required this.level,
  });

  factory CategoriesDto.fromJson(Map<String, dynamic> json) => CategoriesDto(
        category: json["category"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "level": level,
      };
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
