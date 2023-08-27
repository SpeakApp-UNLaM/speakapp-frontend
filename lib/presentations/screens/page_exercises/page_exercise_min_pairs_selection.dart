import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseMinimumPairsSel extends StatefulWidget {
  final int idExercise;
  final List<ImageExercise> images;
  final String namePhoneme;

  const PageExerciseMinimumPairsSel(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idExercise})
      : super(key: key);

  @override
  PageExerciseMinimumPairsSelState createState() =>
      PageExerciseMinimumPairsSelState();
}

//TODO: MEJORAR DISEÑO. LOGICA PRINCIPAL ESTÁ FUNCIONAL
class PageExerciseMinimumPairsSelState
    extends State<PageExerciseMinimumPairsSel> {
  String imageSelected = "";

  @override
  Widget build(BuildContext context) {
    String nameAudio = widget.images.first.name;
    final exerciseProv = context.watch<ExerciseProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '¡Vamos a practicar! \n¿Que imagen se corresponde al siguiente audio?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'IkkaRounded',
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 10.0),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      TtsProvider().speak(nameAudio);
                    },
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 3.0,
                            )),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              drawImages(exerciseProv),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawImages(ExerciseProvider exerciseProv) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: widget.images.map((img) {
        final isSelected = imageSelected == img.name;
        final borderColor = isSelected ? colorList[1] : Colors.grey.shade300;

        return GestureDetector(
          onTap: () {
            if (isSelected) {
              imageSelected = "";
            } else {
              imageSelected = img.name;
            }
            exerciseProv.finishExercise();
            setState(() {});
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                  child: Image.memory(
                    base64.decode(img.base64),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
