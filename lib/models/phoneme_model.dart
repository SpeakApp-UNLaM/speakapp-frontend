import 'dart:convert';

import 'package:sp_front/domain/entities/phoneme.dart';

List<PhonemeModel> groupExerciseModelFromJson(String str) =>
    List<PhonemeModel>.from(
        json.decode(str).map((x) => PhonemeModel.fromJson(x)));

String groupExerciseModelToJson(List<PhonemeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhonemeModel {
  final String wordGroupExercise;
  final int id;

  PhonemeModel({
    required this.wordGroupExercise,
    required this.id,
  });

  factory PhonemeModel.fromJson(Map<String, dynamic> json) => PhonemeModel(
        wordGroupExercise: json["wordGroupExercise"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "wordGroupExercise": wordGroupExercise,
        "id": id,
      };

  Phoneme toGroupExerciseEntity() =>
      Phoneme(id: id, wordGroupExercise: wordGroupExercise);
}
