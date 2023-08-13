import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme/app_theme.dart';
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
    final exerciseProv = context.watch<ExerciseProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '¡Vamos a practicar! \n¿Que imagen se corresponde a cada audio?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'IkkaRounded',
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 10.0),
              Text(widget.namePhoneme,
                  style: TextStyle(
                      fontFamily: 'IkkaRounded',
                      fontSize: 50,
                      color: colorList[1])),
              const SizedBox(height: 50.0),
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
                          print("${checkSelection(exerciseProv)}");
                        });
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              border: Border.all(
                                color: selectedImagePath == img.base64
                                    ? colorList[0]
                                    : Colors.grey.shade300,
                                width: 4.0,
                              )),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  width: 120, // Establecer el ancho deseado
                                  height: 120, // Establecer la altura deseada
                                  child: Image.memory(base64.decode(img.base64),
                                      fit: BoxFit.cover),
                                ),
                              ))),
                    ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          print("${checkSelection(exerciseProv)}");
                        });
                        TtsProvider().speak(img.name);
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              border: Border.all(
                                color: selectedAudioPath == img.name
                                    ? colorList[0]
                                    : Colors.grey.shade300,
                                width: 3.0,
                              )),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.volume_up_outlined,
                                    color: Colors.grey.shade400,
                                  ),
                                  const Text("Reproducir")
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

  bool checkSelection(ExerciseProvider exerciseProv) {
    if (selectedAudioPath != "" && selectedImagePath != "") {
      exerciseProv.finishExercise();
      for (ImageExercise img in widget.images) {
        if (img.name == selectedAudioPath && img.base64 == selectedImagePath) {
          return true;
        }
      }
    }

    return false;
  }
}
