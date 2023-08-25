import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sp_front/config/helpers/param.dart';
import '../../common/common.dart';

class Recorder {
  String _recordingPath = "";
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  final AudioPlayer audioPlayer = AudioPlayer()..setLoopMode(LoopMode.off);
  bool isPlaying = false;
  Recorder() {
    init();
  }
  Future<void> init() async {
    final directory = await getTemporaryDirectory();
    _recordingPath = '${directory.path}/recording.wav';
    //reset();
    if (await Permission.microphone.isGranted) {
      await Permission.storage.request();
    } else {
      await Permission.microphone.request();
    }
  }

  Future<void> startRecording() async {
    try {
      _soundRecorder.openRecorder();
      await _soundRecorder.startRecorder(toFile: _recordingPath);
    } catch (e) {
      Param.showToast("$e");
    }
  }

  Future<void> stopRecording() async {
    await _soundRecorder.stopRecorder();
    try {
      audioPlayer.setFilePath(_recordingPath);
    } catch (e) {
      Param.showToast("$e");
    }
  }

  Future<void> playAudio() async {
    isPlaying = true;
    await audioPlayer.play();
    await audioPlayer.stop();
    await audioPlayer.seek(Duration.zero);
    isPlaying = false;
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    isPlaying = false;
  }

  void disposeRecorder() {
    audioPlayer.dispose();
    _soundRecorder.closeRecorder();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Stream<PositionData> getStreamAudioPlayer() => _positionDataStream;
  String getRecordingPath() => _recordingPath;

  Future<void> reset() async {
    final file = File(_recordingPath);
    audioPlayer.dispose();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
