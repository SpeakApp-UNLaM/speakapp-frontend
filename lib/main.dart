import 'package:flutter/material.dart';
import 'package:sp_front/domain/entities/exercise_r.dart';
import 'package:sp_front/presentations/screens/audio_recorder_screen.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AudioRecorderApp());
}

class AudioRecorderApp extends StatelessWidget {
  const AudioRecorderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => RecorderProvider())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Audio Recorder',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AudioRecorderScreen(
            exercise: ExerciseR(
                img: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/1/12/Mouse_line_drawing.jpg",
                    scale: 3.0),
                letra: "RR",
                name: "Ratón"),
          ),
        ));
  }
}
