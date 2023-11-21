import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
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
  bool speakSlow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('¡Vamos a practicar!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark)),
                SizedBox(height: 10),
                widget.result.split(' ').length == 1
                    ? Text('Reproducí el sónido de la imágen y repetilo:',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Theme.of(context).primaryColorDark))
                    : Text('Pronunciar la siguiente frase:',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Theme.of(context).primaryColorDark)),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  speakSlow = !speakSlow;
                });
                TtsProvider()
                    .speak(widget.result, speakSlow == true ? 0.1 : 0.5);
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ), // Establecer la altura deseada
                    child: SizedBox(
                        width: 200,
                        height: 200,
                        child: widget.img.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      16), // Redondear las esquinas
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Color de la sombra
                                      spreadRadius:
                                          5, // Radio de expansión de la sombra
                                      blurRadius:
                                          7, // Radio de desenfoque de la sombra
                                      offset: Offset(3,
                                          0), // Desplazamiento cero para que la sombra rodee el contenido
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.memory(
                                    base64.decode(widget.img.first.imageData),
                                    fit: BoxFit.cover,
                                    width: Param.tamImages,
                                    height: Param.tamImages,
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Color de la sombra
                                      spreadRadius:
                                          5, // Radio de expansión de la sombra
                                      blurRadius:
                                          7, // Radio de desenfoque de la sombra
                                      offset: Offset(3,
                                          0), // Desplazamiento cero para que la sombra rodee el contenido
                                    ),
                                  ], // Redondear las esquinas
                                ),
                                child: Center(
                                  child: widget.result.split(' ').length == 1
                                      ? AutoSizeText(
                                          widget.result.toUpperCase(),
                                          style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w800,
                                              color: colorList[1],
                                              fontSize: 70),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                        )
                                      : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: AutoSizeText(
                                            widget.result,
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).primaryColorDark,
                                                fontSize: 70),
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                          ),
                                      ),
                                )) // Aquí puedes usar un widget de marcador de posición o el que prefieras
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
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ButtonPlayAudio()),
            ButtonRecorder(
              idExercise: widget.idTaskItem,
            ),
          ],
        ),
      ),
    );
  }
}
