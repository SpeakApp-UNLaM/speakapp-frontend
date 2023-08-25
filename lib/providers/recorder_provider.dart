import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_front/config/helpers/api.dart';
import 'package:sp_front/config/helpers/recorder.dart';
import '../common/common.dart';
import '../config/helpers/param.dart';
import '../domain/entities/transcription.dart';
import '../models/transcription_model.dart';

class RecorderProvider extends ChangeNotifier {
  String _transcripton = "";
  bool _recording = false;
  bool _playing = false;
  Recorder recorder = Recorder();

  bool _existAudio = false;

  bool _exerciseFinished = false;
  String get transcription => _transcripton;
  bool get playing => _playing;
  bool get recordingOn => _recording;
  bool get existAudio => _existAudio;
  bool get isExerciseFinished => _exerciseFinished;
  Future<void> sendTranscription() async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(recorder.getRecordingPath()),
        'model': Param.modelWhisper,
      });

      Response response = await Api.post(Param.postTranscription, formData);

      if (response.statusCode == 200) {
        TranscriptionModel transcriptionModel =
            TranscriptionModel.fromJson(response.data);
        Transcription transcriptionEntity =
            transcriptionModel.toTranscriptionEntity();
        _transcripton = transcriptionEntity.getText();
        log(_transcripton);
        notifyListeners();
      } else {
        Param.showToast("${response.statusCode}");
      }
    } catch (error) {
      Param.showToast('Failed to send transcription. Error: $error');
    }
  }

  Future<void> startRecording() async {
    await recorder.startRecording();
    _recording = true;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await recorder.stopRecording();
    _recording = false;
    _existAudio = true;
    notifyListeners();
  }

  Future<void> playAudio() async {
    _playing = true;
    notifyListeners();
    await recorder.playAudio();
    _playing = false;
    notifyListeners();
  }

  Future<void> pauseAudio() async {
    await recorder.pauseAudio();
    _playing = false;
    notifyListeners();
  }

  Stream<PositionData> getStreamAudioPlayer() =>
      recorder.getStreamAudioPlayer();

  void resetAudio() async {
    recorder.reset();
    _existAudio = false;
    _transcripton = "";
    notifyListeners();
  }

  void finishExercise() {
    _exerciseFinished = true;
    notifyListeners();
  }

  void unfinishExercise() {
    _exerciseFinished = false;
    notifyListeners();
  }
}
