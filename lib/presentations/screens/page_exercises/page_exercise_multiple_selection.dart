import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseMultipleSelection extends StatefulWidget {
  final int idExercise;
  final List<ImageExercise> images;
  final String namePhoneme;
  final String syllable;

  const PageExerciseMultipleSelection(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idExercise,
      required this.syllable})
      : super(key: key);

  @override
  PageExerciseMultipleSelectionState createState() =>
      PageExerciseMultipleSelectionState();
}

class PageExerciseMultipleSelectionState
    extends State<PageExerciseMultipleSelection> {
  List<String> imagesSelected = [];
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
                  '¡Vamos a practicar! \n¿Cuales imagenes contiene el siguiente sonido?',
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
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  GestureDetector(
                    onTap: () {
                      exerciseProv.finishExercise();
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
                              const Text("Reproducir")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
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
                          imagesSelected.remove(image.imageData);
                        } else {
                          TtsProvider().speak(image.name);
                          imagesSelected.add(image.imageData);
                        }
                        exerciseProv.finishExercise();

                        setState(() {});
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                            color: imagesSelected.contains(image.imageData)
                                ? colorList[
                                    imagesSelected.indexOf(image.imageData)]
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
