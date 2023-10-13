import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../domain/entities/result_exercise.dart';
import '../../../domain/entities/result_pair_images.dart';
import '../../../models/image_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseSingleSelectionWord extends StatefulWidget {
  final int idTaskItem;
  final List<ImageExerciseModel> images;
  final String namePhoneme;

  final String syllable;

  const PageExerciseSingleSelectionWord(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idTaskItem,
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
                  '¡Vamos a practicar! \n¿Cuál imágen se corresponde al siguiente fonema?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 40.0),
              drawImages(exerciseProv),
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
                  type: TypeExercise.single_selection_word,
                  audio: "",
                  pairImagesResult: [
                    ResultPairImages(idImage: img.idImage, nameImage: img.name)
                  ]));
              //exerciseProv.finishExercise();
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
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  color: imageSelected == img.name
                      ? colorList[1]
                      : Colors.grey.shade300,
                  width: 3.0,
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
