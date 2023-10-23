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
    widget.images.shuffle();
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
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text('¡Vamos a practicar!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark)),
                const SizedBox(height: 30.0),
                Text('¿Cuál imagen corresponde al siguiente fonema?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Theme.of(context).primaryColorDark)),
                const SizedBox(height: 20.0),
                Text(widget.namePhoneme,
                    style: TextStyle(
                        fontFamily: 'IkkaRounded',
                        fontSize: 50,
                        color: colorList[1])),
                const SizedBox(height: 60.0),
                drawImages(exerciseProv),
              ],
            ),
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
                exerciseProv.unfinishExercise();
              } else {
                imageSelected = img.name;
                TtsProvider().speak(img.name);
                exerciseProv.saveParcialResult(ResultExercise(
                    idTaskItem: widget.idTaskItem,
                    type: TypeExercise.single_selection_word,
                    audio: "",
                    pairImagesResult: [
                      ResultPairImages(
                          idImage: img.idImage, nameImage: img.name)
                    ]));
              }

              //exerciseProv.finishExercise();
              setState(() {});
            },
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black
                                .withOpacity(0.1), // Color de la sombra
                            blurRadius: 5, // Radio de desenfoque
                            offset: Offset(0, 4))
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border: Border.all(
                        color: imageSelected == img.name
                            ? colorList[1]
                            : Colors.transparent,
                        width: 3.0,
                      ),
                    ),
                    width: 160,
                    height: 160,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: _listImages[widget.images.indexOf(img)])),
                Positioned(
                  bottom: 7,
                  right: 7,
                  child: Icon(
                    Icons.volume_up,
                    color: colorList[4],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
