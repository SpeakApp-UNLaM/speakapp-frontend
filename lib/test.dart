import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:sp_front/config/helpers/recorder_new.dart';
import 'package:sp_front/presentations/widgets/button_play_audio.dart';
import 'package:sp_front/presentations/widgets/waveforms.dart';

void main() {
  runApp(const AudioRecorderApp2());
}

class AudioRecorderApp2 extends StatelessWidget {
  const AudioRecorderApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blueAccent, useMaterial3: true),
      home: const PendingScreen2(),
    );
  }
}

class PendingScreen2 extends StatefulWidget {
  const PendingScreen2({Key? key}) : super(key: key);

  @override
  PendingScreenState2 createState() => PendingScreenState2();
}

class PendingScreenState2 extends State<PendingScreen2> {
  // Initialise
  RecorderNew r = RecorderNew();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios2'),
      ),
      body: Column(
        children: [
          FloatingActionButton(
              onPressed: () async {
                r.startRecording();
              },
              child: const Text("iniciar")),
          FloatingActionButton(
              onPressed: () async {
                r.stopRecording();
              },
              child: const Text("parar")),
          const Text("aca!"),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: WaveForm(controller: r.getController()),
          ),
          FloatingActionButton(
            onPressed: () {
              r.startPlayer(); // Pause audio player
            },
            child: Text("play"),
          ),
          FloatingActionButton(
            onPressed: () {
              r.stopPlayer(); // Pause audio player
            },
            child: Text("top"),
          )
        ],
      ),
    );
  }
}
