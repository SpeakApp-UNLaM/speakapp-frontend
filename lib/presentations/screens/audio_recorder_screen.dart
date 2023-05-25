import 'package:flutter/material.dart';
import 'package:sp_front/domain/entities/exercises.dart';
import 'package:sp_front/presentations/widgets/button_recorder.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AudioRecorderScreen extends StatelessWidget {
  final Exercises exercise;
  bool recordingOn = false;

  AudioRecorderScreen({required this.exercise, super.key});

  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Audio Recorder'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                exercise.getLetra(),
                style: GoogleFonts.nunito(
                    fontSize: 50,
                    color: const Color.fromARGB(186, 255, 168, 7)),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Vamos a trabajar silabas que\n contiene este sonido",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: const Color.fromARGB(255, 61, 79, 141)),
              ),
              const SizedBox(
                height: 130,
              ),
              exercise.getImage(),
              const SizedBox(
                height: 150,
              ),
              ButtonRecorder(
                onTap: () {
                  if (recordingOn) {
                    recorderProv.stopRecording();
                  } else {
                    recorderProv.startRecording();
                  }
                  recordingOn = !recordingOn;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Presionar el microfono",
                style: GoogleFonts.nunito(
                  color: const Color.fromARGB(255, 108, 134, 79),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(recorderProv.transcription),
            ],
          ),
        ));
  }
}
