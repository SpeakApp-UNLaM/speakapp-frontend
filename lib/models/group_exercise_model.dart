import 'dart:convert';

import 'package:sp_front/domain/entities/group_exercise.dart';

List<GroupExerciseModel> groupExerciseModelFromJson(String str) =>
    List<GroupExerciseModel>.from(
        json.decode(str).map((x) => GroupExerciseModel.fromJson(x)));

String groupExerciseModelToJson(List<GroupExerciseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupExerciseModel {
  final String wordGroupExercise;
  final int id;

  GroupExerciseModel({
    required this.wordGroupExercise,
    required this.id,
  });

  factory GroupExerciseModel.fromJson(Map<String, dynamic> json) =>
      GroupExerciseModel(
        wordGroupExercise: json["wordGroupExercise"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "wordGroupExercise": wordGroupExercise,
        "id": id,
      };

  GroupExercise toGroupExerciseEntity() =>
      GroupExercise(id: id, wordGroupExercise: wordGroupExercise);
}
