import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sp_front/presentations/screens/page_exercises/pages_exercises.dart';
import '../config/helpers/param.dart';
import 'image_model.dart';

List<ExerciseModel> exerciseModelFromJson(String str) =>
    List<ExerciseModel>.from(
        json.decode(str).map((x) => ExerciseModel.fromJson(x)));

class ExerciseModel {
  int exerciseId;
  TypeExercise type;
  String result;
  List<ImageExerciseModel> images;

  ExerciseModel({
    required this.exerciseId,
    required this.type,
    required this.result,
    required this.images,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      exerciseId: json["idTaskItem"], // Valor predeterminado si es nulo
      type: Param.stringToEnumTypeExercise(json["type"]),
      result: json["result"] ?? "", // Valor predeterminado si es nulo
      images: (json["images"] as List<dynamic>?)
              ?.map((x) => ImageExerciseModel.fromJson(x))
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
      case TypeExercise.speak:
        return PageExerciseSpeak(
          images,
          result,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      case TypeExercise.multiple_match_selection:
        return PageExerciseMultipleMatchSel(
          images: images,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      case TypeExercise.order_syllable:
        return PageExerciseOrderSyllabe(
          img: images.first,
          namePhoneme: letra,
          idExercise: exerciseId,
          syllables: images.first.dividedName,
        );
      case TypeExercise.minimum_pairs_selection:
        return PageExerciseMinimumPairsSel(
            images: images, namePhoneme: letra, idExercise: exerciseId);
      case TypeExercise.multiple_selection:
        return PageExerciseMultipleSelection(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.single_selection_syllable:
        return PageExerciseSingleSelectionSyllable(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.single_selection_word:
        return PageExerciseSingleSelectionWord(
            images: images,
            namePhoneme: letra,
            idExercise: exerciseId,
            syllable: result);
      case TypeExercise.consonantal_syllable:
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
