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
    _listImages.shuffle();
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
              Text('¡Vamos a practicar!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 30.0),
              Text(
                  'Reproducí el sónido de la imágen y selecciona la silaba que contiene',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 60.0),
              drawImages(exerciseProv),
              const SizedBox(height: 50.0),
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
                exerciseProv.unfinishExercise();
              } else {
                syllableSelected = syllable;
                exerciseProv.saveParcialResult(ResultExercise(
                    idTaskItem: widget.idTaskItem,
                    type: TypeExercise.consonantal_syllable,
                    audio: "",
                    pairImagesResult: [
                      ResultPairImages(idImage: 0, nameImage: syllableSelected)
                    ]));
              }

              setState(() {});
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
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
              TtsProvider().speak(img.name, 0.5);
              setState(() {});
            },
            child: Stack(children: [
              Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.5), // Color de la sombra
                        spreadRadius: 5, // Radio de expansión de la sombra
                        blurRadius: 5, // Radio de desenfoque de la sombra
                        offset: Offset(3,
                            0), // Desplazamiento cero para que la sombra rodee el contenido
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _listImages[widget.images.indexOf(img)])),
              Positioned(
                bottom: 7,
                right: 7,
                child: Icon(
                  Icons.volume_up,
                  color: colorList[4],
                  size: 24,
                ),
              )
            ]),
          ),
      ],
    );
  }
}
