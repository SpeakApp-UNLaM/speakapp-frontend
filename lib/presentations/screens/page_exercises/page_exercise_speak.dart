import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/presentations/widgets/button_play_audio.dart';
import 'package:sp_front/presentations/widgets/button_recorder.dart';
import 'package:sp_front/providers/tts_provider.dart';

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
          children: [
            Text('¡Vamos a practicar!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Theme.of(context).primaryColorDark)),
            const SizedBox(height: 30.0),
            Text('Reproducí el sónido de la imágen y repetilo:',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Theme.of(context).primaryColorDark)),
            const SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {
                TtsProvider().speak(widget.result.toUpperCase());
              },
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
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
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 70,
                                  color: colorList[1],
                                ),
                              ),
                            ), // Aquí puedes usar un widget de marcador de posición o el que prefieras
                    ),
                  ),
                  Positioned(
                    bottom: 7,
                    right: 7,
                    child: Icon(
                      Icons.volume_up,
                      color: colorList[4],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ButtonPlayAudio()),
            const SizedBox(height: 40.0),
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
