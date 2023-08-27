import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/models/exercise_model.dart';
import 'package:sp_front/presentations/widgets/button_play_audio.dart';
import 'package:sp_front/presentations/widgets/button_recorder.dart';

class PageExerciseSpeak extends StatefulWidget {
  final ImageExercise img;
  final String namePhoneme;
  final int idExercise;
  const PageExerciseSpeak(
      {required this.idExercise,
      required this.img,
      required this.namePhoneme,
      Key? key})
      : super(key: key);

  @override
  PageExerciseSpeakState createState() => PageExerciseSpeakState();
}

class PageExerciseSpeakState extends State<PageExerciseSpeak> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Vamos a practicar! \nPalabras con la letra:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'IkkaRounded',
                    fontSize: 20,
                    color: Theme.of(context).primaryColorDark)),
            Text(widget.namePhoneme,
                style: TextStyle(
                    fontFamily: 'IkkaRounded',
                    fontSize: 40,
                    color: colorList[1])),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 4.0,
                  )), // Establecer la altura deseada
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.memory(base64.decode(widget.img.base64),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 30.0),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ButtonPlayAudio()),
            const SizedBox(height: 30.0),
            const ButtonRecorder(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
