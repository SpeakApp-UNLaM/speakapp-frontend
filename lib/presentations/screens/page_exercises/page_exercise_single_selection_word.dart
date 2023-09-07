import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../models/image_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseSingleSelectionWord extends StatefulWidget {
  final int idExercise;
  final List<ImageExerciseModel> images;
  final String namePhoneme;

  final String syllable;

  const PageExerciseSingleSelectionWord(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idExercise,
      required this.syllable})
      : super(key: key);

  @override
  PageExerciseSingleSelectionWordState createState() =>
      PageExerciseSingleSelectionWordState();
}

class PageExerciseSingleSelectionWordState
    extends State<PageExerciseSingleSelectionWord> {
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
                  '¡Vamos a practicar! \n¿Cual imagen se corresponde al siguiente fonema?',
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
              Text("Consonántica",
                  style: TextStyle(
                      fontFamily: 'IkkaRounded',
                      fontSize: 20,
                      color: colorList[1])),
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
              exerciseProv.finishExercise();
              setState(() {});
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
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
