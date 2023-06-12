import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  bool exist_audio = false;
  String get transcription => _transcripton;
  bool get playing => _playing;
  bool get recordingOn => _recording;

  Future<void> sendTranscription() async {
    try {
      Api.configureDio(Param.urlServer);

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
        notifyListeners();
      } else {
        throw Exception(
            'Failed to send transcription. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to send transcription. Error: $error');
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
    exist_audio = true;
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
}
