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

  const PageExerciseMinimumPairsSel(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idTaskItem})
      : super(key: key);

  @override
  PageExerciseMinimumPairsSelState createState() =>
      PageExerciseMinimumPairsSelState();
}

class PageExerciseMinimumPairsSelState
    extends State<PageExerciseMinimumPairsSel> {
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
    String nameAudio = widget.images.first.name;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '¡Vamos a practicar! \n¿Qué imágen se corresponde al siguiente audio?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
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
                                Text(
                                  "Reproducir",
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              ],
                            ),
                          ),
                        )),
                  )
                ],
              ),
              const SizedBox(height: 40.0),
              drawImages(),
              const SizedBox(height: 40.0),
            ],
          ),
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
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Color de la sombra
                    blurRadius: 5, // Radio de desenfoque
                    offset: Offset(0, 4))
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                color: borderColor,
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
                    child: _listImages[widget.images.indexOf(img)]),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
