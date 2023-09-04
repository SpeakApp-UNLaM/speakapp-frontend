import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/models/exercise_model.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseOrderSyllabe extends StatefulWidget {
  final ImageExercise img;
  final String namePhoneme;
  final int idExercise;
  final List<String> syllables;
  const PageExerciseOrderSyllabe(
      {required this.idExercise,
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

  @override
  void initState() {
    super.initState();

    _image = Image.memory(
      base64.decode(widget.img.base64),
      fit: BoxFit.cover,
    );
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
              Text('¡Vamos a practicar! \nFormemos la palabra',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'IkkaRounded',
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark)),
              Text(widget.namePhoneme,
                  style: TextStyle(
                      fontFamily: 'IkkaRounded',
                      fontSize: 50,
                      color: colorList[1])),
              const SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  TtsProvider().speak(widget.img.name);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 4.0,
                      )), // Establecer la altura deseada
                  child: SizedBox(
                      height: Param.tamImages,
                      width: Param.tamImages,
                      child: _image),
                ),
              ),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: widget.syllables.asMap().entries.map((entry) {
                  final int index = entry.key;
                  return DragTarget<String>(
                    onAccept: (value) {
                      setState(() {
                        formedWord.removeWhere((element) => element.isEmpty);
                        formedWord.add(value);
                        if (widget.syllables.length > formedWord.length) {
                          formedWord.add("");
                        } else {
                          exerciseProv.finishExercise();
                        }
                      });
                    },
                    builder: (context, acceptedItems, rejectedItems) {
                      return Container(
                        width: 70,
                        height: 70,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (formedWord.length > index)
                              ReorderableSyllableWidget(
                                  syllable: formedWord[index]),
                            Divider(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: widget.syllables
                    .where((syllable) => !formedWord.contains(syllable))
                    .map((syllable) {
                  return Draggable<String>(
                    data: syllable,
                    feedback: ReorderableSyllableWidget(syllable: syllable),
                    childWhenDragging: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        syllable.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: "IkkaRounded",
                          fontSize: 15,
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
                    formedWord.clear();
                    formedWord.add("");
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
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Text(
        syllable.toUpperCase(),
        style: TextStyle(
            fontFamily: "IkkaRounded",
            fontSize: 15,
            color: Theme.of(context).primaryColorDark),
      ),
    );
  }
}
