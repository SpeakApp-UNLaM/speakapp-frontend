import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
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
              Wrap(
                spacing: 10.0,
                runSpacing: 11,
                children: widget.images.map((img) {
                  final isSelected = audiosSelected.contains(img.name);
                  final borderColor = isSelected
                      ? colorList[audiosSelected.indexOf(img.name)]
                      : Colors.grey.shade300;

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        final index = audiosSelected.indexOf(img.name);
                        if (imagesSelected.length >= audiosSelected.length) {
                          imagesSelected.removeAt(index);
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
                          color: borderColor,
                          width: 3.0,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Wrap(
                            children: [
                              Icon(
                                Icons.volume_up_outlined,
                                color: Colors.grey.shade400,
                              ),
                              const Text("Reproducir")
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: widget.images.map((img) {
                  final isSelected = imagesSelected.contains(img.base64);
                  final borderColor = isSelected
                      ? colorList[imagesSelected.indexOf(img.base64)]
                      : Colors.grey.shade300;

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        final index = imagesSelected.indexOf(img.base64);
                        if (audiosSelected.length >= imagesSelected.length) {
                          audiosSelected.removeAt(index);
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
                          color: borderColor,
                          width: 4.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            width: Param.tamImages,
                            height: Param.tamImages,
                            child: Image.memory(base64.decode(img.base64),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
