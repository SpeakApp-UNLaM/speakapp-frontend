import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                const Text("Reproducir")
                              ],
                            ),
                          ),
                        )),
                  )
                ],
              ),
              const SizedBox(height: 5.0),
              GridView.builder(
                shrinkWrap:
                    true, // Asegura que la cuadrícula se ajuste a su contenido
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0, // Espaciado vertical
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1 // Espaciado horizontal
                    ),
                itemCount: widget.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (imagesSelected
                          .contains(widget.images[index].base64)) {
                        imagesSelected.remove(widget.images[index].base64);
                      } else {
                        TtsProvider().speak(widget.images[index].name);
                        imagesSelected.add(widget.images[index].base64);
                      }
                      exerciseProv.finishExercise();

                      setState(() {});
                    },
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            border: Border.all(
                              color: imagesSelected
                                      .contains(widget.images[index].base64)
                                  ? colorList[imagesSelected
                                      .indexOf(widget.images[index].base64)]
                                  : Colors.grey.shade300,
                              width: 4.0,
                            )),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: AspectRatio(
                                aspectRatio: 2, // Establecer la altura deseada
                                child: Image.memory(
                                    base64.decode(widget.images[index].base64),
                                    fit: BoxFit.cover),
                              ),
                            ))),
                  );
                },
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
