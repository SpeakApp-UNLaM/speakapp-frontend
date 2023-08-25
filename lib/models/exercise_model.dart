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

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        exerciseId: json["exerciseId"],
        type: Param.stringToEnum(json["type"]),
        result: json["result"],
        images: List<ImageExercise>.from(
            json["images"].map((x) => ImageExercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "exerciseId": exerciseId,
        "type": type,
        "result": result,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };

  StatefulWidget fromEntity(String letra) {
    switch (type) {
      case TypeExercise.speak:
        return PageExerciseSpeak(
          img: images.first,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      case TypeExercise.multipleMatchSelection:
        return PageExerciseMultipleMatchSel(
          images: images,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      case TypeExercise.orderSyllable:
        return PageExerciseOrderSyllabe(
          img: images.first,
          namePhoneme: letra,
          idExercise: exerciseId,
          syllables: images.first.dividedName,
        );
      case TypeExercise.minimumPairsSelection:
        return PageExerciseMinimumPairsSel(
            images: images, namePhoneme: letra, idExercise: exerciseId);
      case TypeExercise.multipleSelection:
        return PageExerciseMultipleSelection(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.singleSelectionSyllable:
        return PageExerciseSingleSelectionSyllable(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.singleSelectionWord:
        return PageExerciseSingleSelectionWord(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.consonantalSyllable:
        return PageExerciseConsonantalSyllable(
          images: images,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      default:
        return PageExerciseSpeak(
          img: images.first,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
    }
  }
}

class ImageExercise {
  String name;
  String base64;
  List<String> dividedName;

  ImageExercise({
    required this.name,
    required this.base64,
    required this.dividedName,
  });

  factory ImageExercise.fromJson(Map<String, dynamic> json) => ImageExercise(
        name: json["name"],
        base64: json["base64"],
        dividedName: (json["divided_name"]).split('-'),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "base64": base64,
        "divided_name": dividedName,
      };

  List<String> getSyllables() {
    return dividedName;
  }
}
