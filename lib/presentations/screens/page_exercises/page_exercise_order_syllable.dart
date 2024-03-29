import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import '../../../config/helpers/param.dart';
import '../../../domain/entities/result_exercise.dart';
import '../../../models/image_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseOrderSyllabe extends StatefulWidget {
  final ImageExerciseModel img;
  final String namePhoneme;
  final int idTaskItem;
  final List<String> syllables;
  const PageExerciseOrderSyllabe(
      {required this.idTaskItem,
      required this.img,
      required this.namePhoneme,
      required this.syllables,
      Key? key})
      : super(key: key);

  @override
  PageExerciseOrderSyllabeState createState() =>
      PageExerciseOrderSyllabeState();
}

class PageExerciseOrderSyllabeState extends State<PageExerciseOrderSyllabe> {
  List<String> formedWord = [];
  late Image _image;
  List<String> possibleSyllables = [];
  @override
  void initState() {
    super.initState();
    possibleSyllables = [...widget.syllables];
    possibleSyllables.shuffle();
    _image = Image.memory(
      base64.decode(widget.img.imageData),
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProv = context.watch<ExerciseProvider>();
    return Scaffold(
      body: Center(
        child: Padding(
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
                  const SizedBox(height: 20.0),
                  Text('Reproducí el sónido de la imágen y forma la palabra',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Theme.of(context).primaryColorDark)),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  TtsProvider().speak(widget.img.name, 0.5);
                },
                child: Stack(children: [
                  Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.5), // Color de la sombra
                            spreadRadius: 5, // Radio de expansión de la sombra
                            blurRadius: 5, // Radio de desenfoque de la sombra
                            offset: const Offset(3,
                                0), // Desplazamiento cero para que la sombra rodee el contenido
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                      width: 200,
                      height: 200,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _image)),
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
              const Spacer(),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: widget.syllables.asMap().entries.map((entry) {
                  final int index = entry.key;
                  return DragTarget<String>(
                    onAccept: (value) {
                      setState(() {
                        possibleSyllables.remove(value);
                        //formedWord.removeWhere((element) => element.isEmpty);
                        formedWord.add(value);
                        if (widget.syllables.length > formedWord.length) {
                          //formedWord.add("");
                        } else {
                          exerciseProv.saveParcialResult(ResultExercise(
                              idTaskItem: widget.idTaskItem,
                              type: TypeExercise.order_syllable,
                              audio: formedWord.join('-'),
                              pairImagesResult: []));
                          //exerciseProv.finishExercise();
                        }
                      });
                    },
                    builder: (context, acceptedItems, rejectedItems) {
                      return SizedBox(
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (formedWord.length > index)
                              ReorderableSyllableWidget(
                                  syllable: formedWord[index]),
                            SizedBox(
                              width: 70,
                              child: Divider(
                                color: Theme.of(context).primaryColorDark,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: possibleSyllables.map((syllable) {
                  return Draggable<String>(
                    data: syllable,
                    feedback: ReorderableSyllableWidget(syllable: syllable),
                    childWhenDragging: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            syllable.toUpperCase(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        )),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          syllable.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    formedWord = [];
                    possibleSyllables = [...widget.syllables];
                    possibleSyllables.shuffle();
                    exerciseProv.unfinishExercise();
                  });
                },
                child: const Text('Reiniciar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReorderableSyllableWidget extends StatelessWidget {
  final String syllable;
  final Color backgroundColor;

  const ReorderableSyllableWidget({
    required this.syllable,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          syllable.toUpperCase(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
