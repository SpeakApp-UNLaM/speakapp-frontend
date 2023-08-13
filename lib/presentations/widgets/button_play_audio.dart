import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/config/theme/app_theme.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          border: Border.all(
            color:
                recorderProv.existAudio ? Theme.of(context).primaryColorDark : Colors.grey.shade300,
            width: 2.0,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(
                recorderProv.playing ? Icons.pause : Icons.play_arrow,
                color: recorderProv.existAudio ? Theme.of(context).primaryColorDark : Colors.grey.shade300, 
                size: 30,
              ),
              onPressed: !recorderProv.existAudio
                  ? null
                  : () {
                      if (recorderProv.playing) {
                        recorderProv.pauseAudio();
                      } else {
                        recorderProv.playAudio();
                      }
                    }),
          StreamBuilder<PositionData>(
            stream: recorderProv.existAudio ? recorderProv.getStreamAudioPlayer() : const Stream.empty(),
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                disable: recorderProv.existAudio ? true : false,
              );
            },
          ),
          Icon(
            Icons.volume_up_rounded,
            color:
                recorderProv.existAudio ? Theme.of(context).primaryColorDark : Colors.grey.shade300,
          )
        ],
      ),
    );
  }
}
