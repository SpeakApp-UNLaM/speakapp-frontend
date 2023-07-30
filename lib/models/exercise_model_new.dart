import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sp_front/presentations/screens/page_exercises/page_exercise_match_screen.dart';
import '../domain/entities/exercise.dart';
import '../presentations/screens/page_exercises/page_exercise_screen.dart';

List<ExerciseModelNew> exerciseModelFromJson(String str) =>
    List<ExerciseModelNew>.from(
        json.decode(str).map((x) => ExerciseModelNew.fromJson(x)));

String exerciseModelToJson(List<ExerciseModelNew> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseModelNew {
  String type;
  List<ImageExercise> images;
  List<String> silFraseSeparated;

  ExerciseModelNew({
    required this.type,
    required this.images,
    required this.silFraseSeparated,
  });

  factory ExerciseModelNew.fromJson(Map<String, dynamic> json) =>
      ExerciseModelNew(
        type: json["type"],
        images: List<ImageExercise>.from(
            json["images"].map((x) => ImageExercise.fromJson(x))),
        silFraseSeparated:
            List<String>.from(json["sil_frase_separated"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "sil_frase_separated":
            List<dynamic>.from(silFraseSeparated.map((x) => x)),
      };

  StatefulWidget fromEntity(String letra) {
    switch (type) {
      case 'speak':
        return PageExerciseScreen(
            exercise:
                Exercise(id: 1, pathImg: images[0], letra: letra, idGroup: 1));
      case 'listen_selection':
        return PageExerciseMatchScreen(images: images, namePhoneme: letra);
      default:
        return PageExerciseScreen(
            exercise:
                Exercise(id: 1, pathImg: images[0], letra: letra, idGroup: 1));
    }
  }
}

class ImageExercise {
  String index;
  String path;

  ImageExercise({
    required this.index,
    required this.path,
  });

  factory ImageExercise.fromJson(Map<String, dynamic> json) => ImageExercise(
        index: json["index"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "path": path,
      };
}
