import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class ButtonPlayAudio extends StatefulWidget {
  const ButtonPlayAudio({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ButtonPlayAudio createState() => _ButtonPlayAudio();
}

class _ButtonPlayAudio extends State<ButtonPlayAudio> {
  IconData icon = Icons.play_arrow;
  double iRedondeo = 10;
  bool isPlaying = false;
  final audioPlayer = AssetsAudioPlayer();
  // ignore: non_constant_identifier_names
  Color color_icon = const Color.fromARGB(255, 91, 138, 93);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
        if (!isPlaying) {
          _playRecording();
          color_icon = const Color.fromARGB(255, 112, 24, 28);
          icon = Icons.pause;
        } else {
          _stopPlaying();
          icon = Icons.play_arrow;
          color_icon = const Color.fromARGB(255, 91, 138, 93);
        }
        isPlaying = !isPlaying;
        setState(() {});
      },
      backgroundColor: const Color.fromARGB(255, 163, 201, 119),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(iRedondeo),
      ),
      child: Icon(icon, color: color_icon),
    );
  }

  void _playRecording() async {
    final directory = await getTemporaryDirectory();
    String recordingPath = '${directory.path}/recording.mp4';

    audioPlayer.open(
      Audio.file(recordingPath),
      autoStart: true,
      showNotification: true,
    );
  }

  void _stopPlaying() {
    audioPlayer.stop();
  }

  @override
  void initState() {
    super.initState();
  }

  bool isPlayingAudio() => isPlaying;
}
