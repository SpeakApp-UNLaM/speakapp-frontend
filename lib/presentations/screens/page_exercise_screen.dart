import 'package:flutter/material.dart';
import 'package:sp_front/presentations/widgets/button_play_audio.dart';
import 'package:sp_front/presentations/widgets/button_recorder.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/exercise.dart';

class PageExerciseScreen extends StatefulWidget {
  final Exercise exercise;

  const PageExerciseScreen({required this.exercise, Key? key})
      : super(key: key);

  @override
  PageExerciseScreenState createState() => PageExerciseScreenState();
}

class PageExerciseScreenState extends State<PageExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpeakApp'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¡Vamos a practicar! 😄 Palabras con la letra:",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: const Color.fromARGB(255, 61, 79, 141),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.exercise.getLetra(),
                style: GoogleFonts.roboto(
                  fontSize: 50,
                  color: const Color.fromARGB(186, 255, 168, 7),
                ),
              ),
              const SizedBox(height: 40.0),
              widget.exercise.getImage(),
              const SizedBox(height: 40.0),
              const ButtonPlayAudio(),
              const ButtonRecorder(),
              const SizedBox(height: 10),
              Text(
                "Presionar y mantener para grabar",
                style: GoogleFonts.nunito(
                  color: const Color.fromARGB(255, 108, 134, 79),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                recorderProv.transcription,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
