import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/common.dart';

class ButtonPlayAudio extends StatefulWidget {
  @override
  _ButtonPlayAudioState createState() => _ButtonPlayAudioState();
}

class _ButtonPlayAudioState extends State<ButtonPlayAudio>
    with WidgetsBindingObserver {
  late AudioPlayer audioPlayer;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setAsset('assets/test-audio.mp3'); // TODO aca tiene que agarrar el audio correspondiente
    audioPlayer.setLoopMode(
        LoopMode.off); // Opcional: Configura el bucle de reproducción
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioPlayer.stop();
    }
  }

  void playAudio() async {
    // seteamos el state en reproduciendo
    setState(() {
      isPlaying = true;
    });
    await audioPlayer.play();

    await audioPlayer.stop();
    await audioPlayer.seek(Duration.zero);
    setState(() {
      isPlaying = false;
    });
  }

  void pauseAudio() async {
    await audioPlayer.pause();

    setState(() {
      isPlaying = false;
    });
  }

  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
Widget build(BuildContext context) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 127, 163, 85),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            if (isPlaying) {
              pauseAudio();
            } else {
              playAudio();
            }
          },
        ),
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: audioPlayer.seek,
            );
          },
        ),
      ],
    ),
  );
}

}
