import 'package:flutter/material.dart';
import 'package:sp_front/domain/entities/result_exercise.dart';
import 'package:sp_front/models/result_exercise_model.dart';

class ExerciseProvider extends ChangeNotifier {
  bool _existAudio = false;

  bool _exerciseFinished = false;
  bool get existAudio => _existAudio;
  bool get isExerciseFinished => _exerciseFinished;
  late ResultExercise _resultSaved;
  final List<ResultExercise> _listResults = [];
  void finishExercise() {
    _listResults.add(_resultSaved);
    _exerciseFinished = true;
    notifyListeners();
  }

  void unfinishExercise() {
    _exerciseFinished = false;
    notifyListeners();
  }

  void saveParcialResult(resultExercise) {
    _resultSaved = resultExercise;
  }

  void sendResultsExercises() {
    final String jsonExercises =
        resultExerciseModelToJson(_listResults.map((resulExercises) {
      return ResultExerciseModel.resultExerciseToModel(resulExercises);
    }).toList());
    print(jsonExercises);
    _listResults.clear();
  }
}
