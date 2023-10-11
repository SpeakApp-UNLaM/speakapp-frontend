import 'package:flutter/material.dart';
import 'package:sp_front/config/helpers/play_audio_manager.dart';
import 'package:sp_front/config/helpers/recorder.dart';
import '../common/common.dart';
import '../config/helpers/param.dart';

class RecorderProvider extends ChangeNotifier {
  bool _recording = false;
  bool _playing = false;
  Recorder recorder = Recorder();
  PlayAudioManager playManagerAudio = PlayAudioManager();
  bool _existAudio = false;

  bool _exerciseFinished = false;
  bool get playing => _playing;
  bool get recordingOn => _recording;
  bool get existAudio => _existAudio;
  bool get isExerciseFinished => _exerciseFinished;

  Future<void> startRecording() async {
    await recorder.startRecording2();
    _recording = true;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await recorder.stopRecording2();
    _recording = false;
    _existAudio = true;
    notifyListeners();
  }

  Future<void> playAudio() async {
    _playing = true;
    notifyListeners();
    await playManagerAudio.playAudio("${recorder.getPathAudioRecorded()}");
    _playing = false;
    notifyListeners();
  }

  Future<void> pauseAudio() async {
    await playManagerAudio.pauseAudio();
    _playing = false;
    notifyListeners();
  }

  Stream<PositionData> getStreamAudioPlayer() =>
      playManagerAudio.getStreamAudioPlayer();

  void resetProvider() {
    recorder.reset();
    _existAudio = false;
    notifyListeners();
  }

  void resetPathAudio() {
    _existAudio = false;
  }

  void unfinishExercise() {
    _exerciseFinished = false;
    notifyListeners();
  }

  Future<String> convertAudioToBase64() async {
    return await recorder.convertAudioToBase64();
  }
}
