import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_theme.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseMultipleMatchSel extends StatefulWidget {
  final int idExercise;
  final List<ImageExercise> images;
  final String namePhoneme;

  const PageExerciseMultipleMatchSel(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idExercise})
      : super(key: key);

  @override
  PageExerciseMultipleMatchSelState createState() =>
      PageExerciseMultipleMatchSelState();
}

//TODO: MEJORAR DISEÑO. LOGICA PRINCIPAL ESTÁ FUNCIONAL
class PageExerciseMultipleMatchSelState
    extends State<PageExerciseMultipleMatchSel> {
  List<String> audiosSelected = [], imagesSelected = [];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (ImageExercise img in widget.images)
                    GestureDetector(
                      onTap: () {
                        if (audiosSelected.contains(img.name)) {
                          if (imagesSelected.length >= audiosSelected.length) {
                            imagesSelected
                                .removeAt(audiosSelected.indexOf(img.name));
                          }
                          audiosSelected.remove(img.name);
                        } else {
                          TtsProvider().speak(img.name);
                          audiosSelected.add(img.name);
                        }
                        exerciseProv.finishExercise();
                        setState(() {});
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              border: Border.all(
                                color: audiosSelected.contains(img.name)
                                    ? colorList[
                                        audiosSelected.indexOf(img.name)]
                                    : Colors.grey.shade300,
                                width: 3.0,
                              )),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (ImageExercise img in widget.images)
                    GestureDetector(
                      onTap: () {
                        if (imagesSelected.contains(img.base64)) {
                          if (audiosSelected.length >= imagesSelected.length) {
                            audiosSelected
                                .removeAt(imagesSelected.indexOf(img.base64));
                          }
                          imagesSelected.remove(img.base64);
                        } else {
                          imagesSelected.add(img.base64);
                        }
                        exerciseProv.finishExercise();

                        setState(() {});
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              border: Border.all(
                                color: imagesSelected.contains(img.base64)
                                    ? colorList[
                                        imagesSelected.indexOf(img.base64)]
                                    : Colors.grey.shade300,
                                width: 4.0,
                              )),
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
