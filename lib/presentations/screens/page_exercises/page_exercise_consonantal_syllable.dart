import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/domain/entities/result_pair_images.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../domain/entities/result_exercise.dart';
import '../../../models/image_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseConsonantalSyllable extends StatefulWidget {
  final int idTaskItem;
  final List<ImageExerciseModel> images;
  final String namePhoneme;
  final String incorrectSyllable;
  final String correctSyllable;
  const PageExerciseConsonantalSyllable({
    Key? key,
    required this.images,
    required this.namePhoneme,
    required this.idTaskItem,
    required this.incorrectSyllable,
    required this.correctSyllable,
  }) : super(key: key);

  @override
  PageExerciseConsonantalSyllableState createState() =>
      PageExerciseConsonantalSyllableState();
}

class PageExerciseConsonantalSyllableState
    extends State<PageExerciseConsonantalSyllable> {
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

  String syllableSelected = "";
  @override
  Widget build(BuildContext context) {
    final List<String> syllables = [
      widget.incorrectSyllable,
      widget.correctSyllable,
    ];
    final exerciseProv = context.watch<ExerciseProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '¡Vamos a practicar! \nSeleccione el fonema de la siguiente imágen',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 40.0),
              drawImages(exerciseProv),
              const SizedBox(height: 40.0),
              drawElements(exerciseProv, syllables)
            ],
          ),
        ),
      ),
    );
  }

  Widget drawElements(ExerciseProvider exerciseProv, List<String> syllables) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        for (String syllable in syllables)
          GestureDetector(
            onTap: () {
              if (syllableSelected == syllable) {
                syllableSelected = "";
              } else {
                syllableSelected = syllable;
              }
              exerciseProv.saveParcialResult(ResultExercise(
                  idTaskItem: widget.idTaskItem,
                  type: TypeExercise.consonantal_syllable,
                  audio: "",
                  pairImagesResult: [
                    ResultPairImages(idImage: 0, nameImage: syllableSelected)
                  ]));
              setState(() {});
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color:
                          Colors.black.withOpacity(0.1), // Color de la sombra
                      blurRadius: 5, // Radio de desenfoque
                      offset: Offset(0, 4))
                ],
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  color: syllableSelected == syllable
                      ? colorList[1]
                      : Colors.grey.shade300,
                  width: 3.0,
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Wrap(
                    children: [
                      Text(syllable,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium)
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget drawImages(ExerciseProvider exerciseProv) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (ImageExerciseModel img in widget.images)
          GestureDetector(
            onTap: () {
              TtsProvider().speak(img.name);
              setState(() {});
            },
            child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 4.0,
                    )),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: Param.tamImages, // Establecer el ancho deseado
                        height: Param.tamImages, // Establecer la altura deseada
                        child: _listImages[widget.images.indexOf(img)],
                      ),
                    ))),
          ),
      ],
    );
  }
}
