import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/domain/entities/result_pair_images.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../domain/entities/result_exercise.dart';
import '../../../models/image_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseSingleSelectionSyllable extends StatefulWidget {
  final int idTaskItem;
  final List<ImageExerciseModel> images;
  final String namePhoneme;

  final String syllable;

  const PageExerciseSingleSelectionSyllable(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idTaskItem,
      required this.syllable})
      : super(key: key);

  @override
  PageExerciseSingleSelectionSyllableState createState() =>
      PageExerciseSingleSelectionSyllableState();
}

class PageExerciseSingleSelectionSyllableState
    extends State<PageExerciseSingleSelectionSyllable> {
  String imageSelected = "";
  late List<Image> _listImages;

  @override
  void initState() {
    super.initState();

    _listImages = widget.images.map((img) {
      return Image.memory(
        base64.decode(img.imageData),
        fit: BoxFit.cover,
      );
    }).toList();
  }

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
                  '¡Vamos a practicar! \n¿Cual imagen se corresponde al siguiente sonido?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'IkkaRounded',
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 10.0),
              Text(widget.syllable.toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'IkkaRounded',
                      fontSize: 50,
                      color: colorList[1])),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      TtsProvider().speak(widget.syllable);
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
      children: [
        for (ImageExerciseModel img in widget.images)
          GestureDetector(
            onTap: () {
              if (imageSelected == img.name) {
                imageSelected = "";
              } else {
                imageSelected = img.name;
                TtsProvider().speak(img.name);
              }
              exerciseProv.saveParcialResult(ResultExercise(
                  idTaskItem: widget.idTaskItem,
                  type: TypeExercise.single_selection_syllable,
                  audio: "",
                  pairImagesResult: [
                    ResultPairImages(idImage: img.idImage, nameImage: img.name)
                  ]));
              //exerciseProv.finishExercise();
              setState(() {});
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  color: imageSelected == img.name
                      ? colorList[1]
                      : Colors.grey.shade300,
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
                    child: _listImages[widget.images.indexOf(img)],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
