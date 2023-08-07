import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sp_front/presentations/screens/page_exercises/page_exercise_match.dart';
import '../config/helpers/param.dart';
import '../presentations/screens/page_exercises/page_exercise_recoder.dart';

List<ExerciseModelNew> exerciseModelFromJson(String str) =>
    List<ExerciseModelNew>.from(
        json.decode(str).map((x) => ExerciseModelNew.fromJson(x)));

String exerciseModelToJson(List<ExerciseModelNew> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseModelNew {
  int exerciseId;
  TypeExercise type;
  String result;
  List<ImageExercise> images;

  ExerciseModelNew({
    required this.exerciseId,
    required this.type,
    required this.result,
    required this.images,
  });

  factory ExerciseModelNew.fromJson(Map<String, dynamic> json) =>
      ExerciseModelNew(
        exerciseId: json["exerciseId"],
        type: json["type"],
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
        return PageExerciseRecord(
          img: images.first,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      case TypeExercise.listenSelection:
        return PageExerciseMatch(
          images: images,
          namePhoneme: letra,
          idExercise: exerciseId,
        );
      default:
        return PageExerciseRecord(
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
  String dividedName;

  ImageExercise({
    required this.name,
    required this.base64,
    required this.dividedName,
  });

  factory ImageExercise.fromJson(Map<String, dynamic> json) => ImageExercise(
        name: json["name"],
        base64: json["base64"],
        dividedName: json["divided_name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "base64": base64,
        "divided_name": dividedName,
      };
}
