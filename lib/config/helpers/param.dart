import 'package:path_provider/path_provider.dart';

class Param {
  static const urlServer = "http://192.168.0.107:9292/speak-app";
  static const postTranscription = "/speech-recognition/transcription";
  static const modelWhisper = "whisper-1";

  static Future<String> getRecordingPath() async {
    return getTemporaryDirectory().then((value) {
      return '${value.path}}/recording.mp4';
    });
  }
}
