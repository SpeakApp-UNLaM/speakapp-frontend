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

class PageExerciseMultipleSelection extends StatefulWidget {
  final int idTaskItem;
  final List<ImageExerciseModel> images;
  final String namePhoneme;
  final String syllable;

  const PageExerciseMultipleSelection(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idTaskItem,
      required this.syllable})
      : super(key: key);

  @override
  PageExerciseMultipleSelectionState createState() =>
      PageExerciseMultipleSelectionState();
}

class PageExerciseMultipleSelectionState
    extends State<PageExerciseMultipleSelection> {
  List<String> imagesSelected = [];
  List<ResultPairImages> pairImages = [];
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
    const colors = <Color>[
      Color(0xFFffa834),
      Color(0xFF72bb53),
      Color(0xFF91e4fb),
      Color(0xFFce82ff),
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
                  '¡Vamos a practicar! \n¿Cuál o cuáles imagenes contiene el siguiente sonido?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  GestureDetector(
                    onTap: () {
                      //exerciseProv.finishExercise();
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
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Wrap(
                            children: [
                              Icon(
                                Icons.volume_up_outlined,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(width: 10),
                              Text("Reproducir",
                                  style: Theme.of(context).textTheme.titleSmall)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  for (var image in widget.images)
                    GestureDetector(
                      onTap: () {
                        final isSelected =
                            imagesSelected.contains(image.imageData);
                        if (isSelected) {
                          int index = imagesSelected.indexOf(image.imageData);
                          imagesSelected.remove(image.imageData);
                          pairImages.removeAt(index);
                        } else {
                          TtsProvider().speak(image.name);
                          imagesSelected.add(image.imageData);
                          pairImages.add(ResultPairImages(
                              idImage: image.idImage, nameImage: image.name));
                        }
                        exerciseProv.saveParcialResult(ResultExercise(
                            idTaskItem: widget.idTaskItem,
                            type: TypeExercise.multiple_selection,
                            audio: "",
                            pairImagesResult: pairImages));
                        //exerciseProv.finishExercise();

                        setState(() {});
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Color de la sombra
                                blurRadius: 5, // Radio de desenfoque
                                offset: Offset(0, 4))
                          ],
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                            color: imagesSelected.contains(image.imageData)
                                ? colors[
                                    imagesSelected.indexOf(image.imageData)]
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
                                child:
                                    _listImages[widget.images.indexOf(image)]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
