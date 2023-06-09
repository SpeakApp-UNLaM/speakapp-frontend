// To parse this JSON data, do
//
//     final exerciseModel = exerciseModelFromJson(jsonString);

import 'dart:convert';

import '../domain/entities/exercise.dart';

List<ExerciseModel> exerciseModelFromJson(String str) =>
    List<ExerciseModel>.from(
        json.decode(str).map((x) => ExerciseModel.fromJson(x)));

String exerciseModelToJson(List<ExerciseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseModel {
  final String wordExercise;
  final int idGroupExercise;
  final String urlImageRelated;
  final String resultExpected;
  final int level;
  final int id;
  ExerciseModel({
    required this.wordExercise,
    required this.idGroupExercise,
    required this.urlImageRelated,
    required this.resultExpected,
    required this.level,
    required this.id,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        wordExercise: json["wordExercise"],
        idGroupExercise: json["idGroupExercise"],
        urlImageRelated: json["urlImageRelated"],
        resultExpected: json["resultExpected"],
        level: json["level"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "wordExercise": wordExercise,
        "idGroupExercise": idGroupExercise,
        "urlImageRelated": urlImageRelated,
        "resultExpected": resultExpected,
        "level": level,
        "id": id
      };
  Exercise toExerciseEntity() => Exercise(
        id: id,
        idGroup: idGroupExercise,
        level: level,
        resultExpected: resultExpected,
        pathImg: urlImageRelated,
        letra: wordExercise,
      );
}
