import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseMatch extends StatefulWidget {
  final int idExercise;
  final List<ImageExercise> images;
  final String namePhoneme;
  const PageExerciseMatch(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idExercise})
      : super(key: key);

  @override
  PageExerciseMatchState createState() => PageExerciseMatchState();
}

//TODO: MEJORAR DISEÑO. LOGICA PRINCIPAL ESTÁ FUNCIONAL
class PageExerciseMatchState extends State<PageExerciseMatch> {
  String selectedImagePath = "";
  String selectedAudioPath = "";
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
                widget.namePhoneme,
                style: GoogleFonts.roboto(
                  fontSize: 50,
                  color: const Color.fromARGB(186, 255, 168, 7),
                ),
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (ImageExercise img in widget.images)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedImagePath != "" &&
                              img.base64 == selectedImagePath) {
                            selectedImagePath = "";
                          } else {
                            selectedImagePath = img.base64;
                          }
                          print("${checkSelection(recorderProv)}");
                        });
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: selectedImagePath == img.base64
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3.0,
                          )),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: 180, // Establecer el ancho deseado
                              height: 180, // Establecer la altura deseada
                              child: Image.memory(base64.decode(img.base64),
                                  fit: BoxFit.cover),
                            ),
                          )),
                    ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (ImageExercise img in widget.images)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedAudioPath != "" &&
                              img.name == selectedAudioPath) {
                            selectedAudioPath = "";
                          } else {
                            selectedAudioPath = img.name;
                          }
                          print("${checkSelection(recorderProv)}");
                        });
                        TtsProvider().speak(img.name);
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: selectedAudioPath == img.name
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3.0,
                          )),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Padding(
                              padding: EdgeInsets.all(3),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.headset_rounded,
                                  )
                                ],
                              ),
                            ),
                          )),
                    )
                ],
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  bool checkSelection(final recorderProv) {
    if (selectedAudioPath != "" && selectedImagePath != "") {
      recorderProv.finishExercise();
      for (ImageExercise img in widget.images) {
        if (img.name == selectedAudioPath && img.base64 == selectedImagePath) {
          return true;
        }
      }
    }

    return false;
  }
}
