import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_front/domain/entities/result_exercise.dart';
import 'package:sp_front/models/result_exercise_model.dart';

import '../config/helpers/api.dart';
import '../config/helpers/param.dart';

class ExerciseProvider extends ChangeNotifier {
  bool _existAudio = false;

  bool _exerciseFinished = false;
  bool get existAudio => _existAudio;
  bool get isExerciseFinished => _exerciseFinished;
  late ResultExercise _resultSaved;
  final List<ResultExercise> _listResults = [];
  void finishExercise() {
    _listResults.add(_resultSaved);
    _exerciseFinished = false;
    notifyListeners();
  }

  void unfinishExercise() {
    _exerciseFinished = false;
    notifyListeners();
  }

  void saveParcialResult(resultExercise) {
    _resultSaved = resultExercise;
    _exerciseFinished = true;
    notifyListeners();
  }

  Future<void> sendResultsExercises() async {
    final jsonExercises =
        resultExerciseModelToJson(_listResults.map((resulExercises) {
      return ResultExerciseModel.resultExerciseToModel(resulExercises);
    }).toList());
    print("aca $jsonExercises");
    Response response =
        await Api.post(Param.postSaveResultExercises, jsonExercises);
    if (response.statusCode == 200) {
      print("OK!");
    } else {
      print("NO OK MANIN!");
    }
    print(jsonExercises);
    _listResults.clear();
    _exerciseFinished = false;
  }
}
