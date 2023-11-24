import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../common/common.dart';

class PlayAudioManager {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  PlayAudioManager() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> playAudio(String pathAudio) async {
    isPlaying = true;
    await _audioPlayer.setFilePath(pathAudio);
    await _audioPlayer.play();
    await _audioPlayer.stop();

    await _audioPlayer.seek(Duration.zero, index: 0);

    isPlaying = false;
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    isPlaying = false;
  }

  void disposeRecorder() {
    _audioPlayer.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Stream<PositionData> getStreamAudioPlayer() => _positionDataStream;

  void reset() {
    _audioPlayer.dispose();
  }
}
