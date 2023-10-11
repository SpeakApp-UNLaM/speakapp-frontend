import 'dart:convert';

import 'package:sp_front/models/result_pair_images_model.dart';

import '../domain/entities/result_exercise.dart';

String resultExerciseModelToJson(List<ResultExerciseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResultExerciseModel {
  int idTaskItem;
  String audio;
  List<ResultPairImagesModel> pairList;

  ResultExerciseModel({
    required this.idTaskItem,
    required this.audio,
    required this.pairList,
  });

  Map<String, dynamic> toJson() => {
        "idTaskItem": idTaskItem,
        "audio": audio,
        "selectionImages": List<dynamic>.from(pairList.map((x) => x.toJson())),
      };

  static ResultExerciseModel resultExerciseToModel(ResultExercise e) =>
      ResultExerciseModel(
        audio: e.audio,
        idTaskItem: e.idTaskItem,
        pairList: e.pairImagesResult.map((resultPairImages) {
          return ResultPairImagesModel.resultPairImagesToModel(
              resultPairImages);
        }).toList(),
      );
}
