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
  bool speakSlow = true;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Text('¡Vamos a practicar!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark)),
                SizedBox(height: 15),
                Text('¿Cuál imagen contiene el siguiente sonido?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Theme.of(context).primaryColorDark)),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //exerciseProv.finishExercise();
                        setState(() {
                          speakSlow = !speakSlow;
                        });
                        TtsProvider().speak(
                            widget.syllable, speakSlow == true ? 0.1 : 0.5);
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Color de la sombra
                                blurRadius: 5, // Radio de desenfoque
                                offset: Offset(0, 5))
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 100, // Ancho mínimo deseado
                            maxWidth: MediaQuery.of(context).size.width *
                                0.35, // Ancho máximo del 30% del ancho disponible
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.volume_up_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text("Reproducir",
                                    style: GoogleFonts.nunito(
                                        fontSize: 14, color: Colors.white))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(flex: 1),
            Center(child: drawImages(exerciseProv)),
            const Spacer(flex: 1),
          ],
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
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (imageSelected == img.name) {
                    imageSelected = "";
                    exerciseProv.unfinishExercise();
                  } else {
                    imageSelected = img.name;
                    TtsProvider().speak(img.name, 0.5);
                    exerciseProv.saveParcialResult(ResultExercise(
                        idTaskItem: widget.idTaskItem,
                        type: TypeExercise.single_selection_syllable,
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
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
              SizedBox(height: 15),
              Text(img.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark))
            ],
          ),
      ],
    );
  }
}
