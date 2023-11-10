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

class PageExerciseOrderWord extends StatefulWidget {
  final String namePhoneme;
  final int idTaskItem;
  final List<String> words;
  final String result;
  const PageExerciseOrderWord(
      {required this.idTaskItem,
      required this.namePhoneme,
      required this.words,
      required this.result,
      Key? key})
      : super(key: key);

  @override
  PageExerciseOrderWordState createState() => PageExerciseOrderWordState();
}

class PageExerciseOrderWordState extends State<PageExerciseOrderWord> {
  bool speakSlow = true;

  List<String> formedWord = [];
  List<String> possibleWords = [];
  @override
  void initState() {
    super.initState();
    possibleWords = [...widget.words];
    possibleWords.shuffle();
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
                  Text('Reproducí el audio y luego forma la frase',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Theme.of(context).primaryColorDark)),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      //exerciseProv.finishExercise();
                      setState(() {
                        speakSlow = !speakSlow;
                      });
                      TtsProvider()
                          .speak(widget.result, speakSlow == true ? 0.1 : 0.5);
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
              const Spacer(),
              Wrap(
                children: widget.words.asMap().entries.map((entry) {
                  final int index = entry.key;
                  return DragTarget<String>(
                    onAccept: (value) {
                      setState(() {
                        possibleWords.remove(value);
                        //formedWord.removeWhere((element) => element.isEmpty);
                        formedWord.add(value);
                        if (widget.words.length > formedWord.length) {
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
                              width: 100,
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
                children: possibleWords.map((syllable) {
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
                    possibleWords = [...widget.words];
                    possibleWords.shuffle();
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
