import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/common.dart';
import '../../providers/recorder_provider.dart';

class ButtonPlayAudio extends StatefulWidget {
  const ButtonPlayAudio({super.key});

  @override
  ButtonPlayAudioState createState() => ButtonPlayAudioState();
}

class ButtonPlayAudioState extends State<ButtonPlayAudio>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (recorderProv.existAudio)
            IconButton(
              icon: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 127, 163, 85),
                child: Icon(
                  recorderProv.playing ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (recorderProv.playing) {
                  recorderProv.pauseAudio();
                } else {
                  recorderProv.playAudio();
                }
              },
            ),
          if (recorderProv.existAudio)
            StreamBuilder<PositionData>(
              stream: recorderProv.getStreamAudioPlayer(),
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                );
              },
            ),
        ],
      ),
    );
  }
}
