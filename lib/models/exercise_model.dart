import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sp_front/presentations/screens/page_exercises/pages_exercises.dart';
import '../config/helpers/param.dart';

List<ExerciseModel> exerciseModelFromJson(String str) =>
    List<ExerciseModel>.from(
        json.decode(str).map((x) => ExerciseModel.fromJson(x)));

String exerciseModelToJson(List<ExerciseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseModel {
  int exerciseId;
  TypeExercise type;
  String result;
  List<ImageExercise> images;

  ExerciseModel({
    required this.exerciseId,
    required this.type,
    required this.result,
    required this.images,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      exerciseId: json["exerciseId"] ?? 0, // Valor predeterminado si es nulo
      type: Param.stringToEnumTypeExercise(json["type"]),
      result: json["result"] ?? "", // Valor predeterminado si es nulo
      images: (json["images"] as List<dynamic>?)
              ?.map((x) => ImageExercise.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "exerciseId": exerciseId,
        "type": type,
        "result": result,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };

  StatefulWidget fromEntity(String letra) {
    switch (type) {
      case TypeExercise.SPEAK:
        return PageExerciseSpeak(
          images,
          result,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      case TypeExercise.MULTIPLE_MATCH_SELECTION:
        return PageExerciseMultipleMatchSel(
          images: images,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      case TypeExercise.ORDER_SYLLABLE:
        return PageExerciseOrderSyllabe(
          img: images.first,
          namePhoneme: letra,
          idExercise: exerciseId,
          syllables: images.first.dividedName,
        );
      case TypeExercise.MINIMUM_PAIRS_SELECTION:
        return PageExerciseMinimumPairsSel(
            images: images, namePhoneme: letra, idExercise: exerciseId);
      case TypeExercise.MULTIPLE_SELECTION:
        return PageExerciseMultipleSelection(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.SINGLE_SELECTION_SYLLABLE:
        return PageExerciseSingleSelectionSyllable(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.SINGLE_SELECTION_WORD:
        return PageExerciseSingleSelectionWord(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.CONSONANTAL_SYLLABLE:
        return PageExerciseConsonantalSyllable(
          images: images,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      default:
        return PageExerciseSpeak(
          images,
          result,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
    }
  }
}

class ImageExercise {
  String name;
  String imageData;
  List<String> dividedName;

  ImageExercise({
    required this.name,
    required this.imageData,
    required this.dividedName,
  });

  factory ImageExercise.fromJson(Map<String, dynamic> json) {
    return ImageExercise(
      name: json["name"] ?? "",
      imageData: json["imageData"] ?? "",
      dividedName: (json["dividedName"] as String?)?.split('-') ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageData": imageData,
        "dividedName": dividedName,
      };

  List<String> getSyllables() {
    return dividedName;
  }
}
