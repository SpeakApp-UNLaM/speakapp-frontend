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

class PageExerciseMinimumPairsSel extends StatefulWidget {
  final int idTaskItem;
  final List<ImageExerciseModel> images;
  final String namePhoneme;
  final String result;

  const PageExerciseMinimumPairsSel(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idTaskItem,
      required this.result})
      : super(key: key);

  @override
  PageExerciseMinimumPairsSelState createState() =>
      PageExerciseMinimumPairsSelState();
}

class PageExerciseMinimumPairsSelState
    extends State<PageExerciseMinimumPairsSel> {
  bool speakSlow = true;

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
    _listImages.shuffle();
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 15),
                Text('¿Qué imágen se corresponde al siguiente audio?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Theme.of(context).primaryColorDark)),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          speakSlow = !speakSlow;
                        });
                        TtsProvider().speak(
                            widget.result, speakSlow == true ? 0.1 : 0.5);
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
                    )
                  ],
                ),
              ],
            ),
            Spacer(),
            drawImages(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget drawImages() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: widget.images.map((img) {
        final isSelected = imageSelected == img.name;
        final borderColor = isSelected ? colorList[1] : Colors.grey.shade300;

        return GestureDetector(
          key: ValueKey(img.name),
          onTap: () {
            setState(() {
              if (isSelected) {
                imageSelected = "";
                context.read<ExerciseProvider>().unfinishExercise();
              } else {
                imageSelected = img.name;
                context.read<ExerciseProvider>().saveParcialResult(
                        ResultExercise(
                            idTaskItem: widget.idTaskItem,
                            type: TypeExercise.minimum_pairs_selection,
                            audio: "",
                            pairImagesResult: [
                          ResultPairImages(
                              idImage: img.idImage, nameImage: imageSelected)
                        ]));
              }

              //context.read<ExerciseProvider>().finishExercise();
            });
          },
          child: Container(
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
        );
      }).toList(),
    );
  }
}
