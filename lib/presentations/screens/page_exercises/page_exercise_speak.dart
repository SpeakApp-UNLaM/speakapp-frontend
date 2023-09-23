import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/presentations/widgets/button_play_audio.dart';
import 'package:sp_front/presentations/widgets/button_recorder.dart';

import '../../../config/helpers/param.dart';
import '../../../models/image_model.dart';

class PageExerciseSpeak extends StatefulWidget {
  final List<ImageExerciseModel> img;
  final String namePhoneme;
  final int idTaskItem;
  final String result;
  const PageExerciseSpeak(this.img, this.result,
      {required this.idTaskItem, required this.namePhoneme, Key? key})
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
                width: Param.tamImages,
                height: Param.tamImages,
                child: widget.img.isNotEmpty
                    ? Image.memory(
                        base64.decode(widget.img.first.imageData),
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          widget.result.toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'IkkaRounded',
                              fontSize: 70,
                              color: colorList[1]),
                        ),
                      ), // Aquí puedes usar un widget de marcador de posición o el que prefieras
              ),
            ),
            const SizedBox(height: 30.0),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ButtonPlayAudio()),
            const SizedBox(height: 30.0),
            ButtonRecorder(
              idExercise: widget.idTaskItem,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
