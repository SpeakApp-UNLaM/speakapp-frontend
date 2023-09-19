import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_front/config/helpers/param.dart';

class Recorder {
  String? _lastRecordedPath = "";
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();

  Recorder() {
    init();
  }
  Future<void> init() async {
    if (await Permission.microphone.isGranted) {
      await Permission.storage.request();
    } else {
      await Permission.microphone.request();
    }
  }

  Future<void> startRecording2() async {
    try {
      _soundRecorder.openRecorder();
      await _soundRecorder.startRecorder(toFile: "record.mp4", bitRate: 48000);
    } catch (e) {
      Param.showToast("Error al iniciar la grabación: $e");
    }
  }

  Future<String?> stopRecording2() async {
    try {
      _lastRecordedPath = await _soundRecorder.stopRecorder();
    } catch (e) {
      Param.showToast("Error al detener la grabación: $e");
    }
    return _lastRecordedPath;
  }

  String? getPathAudioRecorded() {
    return _lastRecordedPath;
  }

  void reset() {
    _soundRecorder.closeRecorder();
    _deleteFile();
  }

  Future<String> convertAudioToBase64() async {
    File audioFile = File("$_lastRecordedPath");
    Uint8List bytes = await audioFile.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _deleteFile() async {
    try {
      final file = File("$_lastRecordedPath");

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      Param.showToast('Error al eliminar el archivo: $e');
    }
  }
}
