import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_front/config/helpers/api.dart';
import 'package:sp_front/config/helpers/recorder.dart';
import '../config/helpers/param.dart';
import '../domain/entities/transcription.dart';
import '../models/transcription_model.dart';

class RecorderProvider extends ChangeNotifier {
  String _transcripton = "";
  Recorder recorder = Recorder();
  String get transcription => _transcripton;
  bool _recording = false;
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
        _recording = false;
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

  void startRecording() {
    recorder.startRecording();
    _recording = true;
    notifyListeners();
  }

  void stopRecording() {
    recorder.stopRecording();
    _recording = false;
    sendTranscription();
  }
}
