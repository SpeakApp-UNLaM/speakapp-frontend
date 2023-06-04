import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class Recorder {
  late String _recordingPath;
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  Future<void> init() async {
    final directory = await getTemporaryDirectory();
    _recordingPath = '${directory.path}/recording.wav';

    if (await Permission.microphone.isGranted) {
      await Permission.storage.request();
    } else {
      // Request the permission to record audio.
      await Permission.microphone.request();
    }
  }

  String getRecordingPath() => _recordingPath;

  Recorder() {
    init();
  }
  Future<void> startRecording() async {
    _soundRecorder.openRecorder();
    if (!_soundRecorder.isRecording) {
      await _soundRecorder.startRecorder(toFile: _recordingPath);
    }
  }

  Future<void> stopRecording() async {
    _soundRecorder.closeRecorder();
    await _soundRecorder.stopRecorder();
  }
}
