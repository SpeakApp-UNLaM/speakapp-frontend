import 'package:flutter/material.dart';
import 'package:sp_front/domain/entities/result_exercise.dart';
import 'package:sp_front/models/result_exercise_model.dart';
import 'package:sp_front/models/rfi_model.dart';

import '../config/helpers/api.dart';
import '../config/helpers/param.dart';

class ExerciseProvider extends ChangeNotifier {
  bool _existAudio = false;
  int idPhonemeActive = 0;
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

  void initExercise() {
    _exerciseFinished = false;
  }

  void unfinishExercise() {
    _exerciseFinished = false;
    notifyListeners();
  }

  Future<void> saveParcialResult(resultExercise) async {
    _resultSaved = resultExercise;
    _exerciseFinished = true;
    notifyListeners();
  }

  Future<void> sendResultsExercises() async {
    final jsonExercises =
        resultExerciseModelToJson(_listResults.map((resulExercises) {
      return ResultExerciseModel.resultExerciseToModel(resulExercises);
    }).toList());

    await Api.post(Param.postSaveResultExercises, jsonExercises);
    //print("a eliminar: $idPhonemeActive");
    //await Api.delete("${Param.deleteTask}/$idPhonemeActive", {});
    idPhonemeActive = 0;
    _listResults.clear();
    _exerciseFinished = false;
  }

  void setIdTaskActive(int idPhoneme) {
    idPhonemeActive = idPhoneme;
  }

  void sendRFIResults(List<RFIExerciseModel> rfiResults, int idPatient) async {
    _exerciseFinished = false;
    await Api.post(
        "${Param.postRfi}/$idPatient", RFIExerciseModelToJson(rfiResults));
    idPhonemeActive = 0;
    _listResults.clear();
  }
}
