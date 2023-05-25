import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_front/config/helpers/api.dart';
import '../config/helpers/param.dart';
import '../domain/entities/transcription.dart';
import '../models/transcription_model.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class RecorderProvider extends ChangeNotifier {
  String _transcripton = "";
  bool _recordingOn = false;
  String _recordingPath = "";
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();

  String get transcription => _transcripton;
  bool get recordingOn => _recordingOn;

  Future<void> sendTranscription() async {
    Api.configureDio(Param.urlServer);
    String recordingPath = await Param.getRecordingPath();
    MultipartFile f = MultipartFile.fromFileSync(recordingPath);
    Future<FormData> createFormData() async {
      return FormData.fromMap({
        'model': Param.modelWhisper,
        'file': f,
      });
    }

    FormData formD = await createFormData();
    Response response = await Api.post(Param.postTranscription, formD);
    var d = TranscriptionModel.fromJson(response.data);
    Transcription transcription = d.toTranscriptionEntity();

    _transcripton = transcription.getText();
    _recordingOn = false;
    notifyListeners();
  }

  Future<void> startRecording() async {
    _recordingOn = true;
    _recordingPath = await Param.getRecordingPath();

    _soundRecorder.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _soundRecorder
        .setSubscriptionDuration(const Duration(milliseconds: 10));
    await initializeDateFormatting();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    Directory d = Directory(path.dirname(_recordingPath));
    if (!d.existsSync()) {
      d.createSync();
    }
    _soundRecorder.openAudioSession();
    await _soundRecorder.startRecorder(
        toFile: _recordingPath, codec: Codec.aacMP4);
    notifyListeners();
  }

  Future<void> stopRecording() async {
    _soundRecorder.closeAudioSession();
    await _soundRecorder.stopRecorder();
    sendTranscription();
  }
}
