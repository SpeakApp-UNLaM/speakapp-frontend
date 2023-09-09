import 'package:flutter/material.dart';

class ExerciseProvider extends ChangeNotifier {
  bool _existAudio = false;

  bool _exerciseFinished = false;
  bool get existAudio => _existAudio;
  bool get isExerciseFinished => _exerciseFinished;

  void finishExercise() {
    _exerciseFinished = true;
    notifyListeners();
  }

  void unfinishExercise() {
    _exerciseFinished = false;
    notifyListeners();
  }
}
