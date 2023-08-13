import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/models/exercise_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/providers/exercise_provider.dart';

import '../../../providers/recorder_provider.dart';

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
  List<String> formedWord = [''];
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
                "¡Vamos a practicar! 😄 Palabras con la letra:",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: const Color.fromARGB(255, 61, 79, 141),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.namePhoneme,
                style: GoogleFonts.roboto(
                  fontSize: 50,
                  color: const Color.fromARGB(186, 255, 168, 7),
                ),
              ),
              const SizedBox(height: 40.0),
              SizedBox(
                width: 200, // Establecer el ancho deseado
                height: 200, // Establecer la altura deseada
                child: Image.memory(base64.decode(widget.img.base64),
                    fit: BoxFit.cover),
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: formedWord.asMap().entries.map((entry) {
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
                      return Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  formedWord[index],
                                ),
                                const Divider(
                                  color: Color(0xFF008db1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10)
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.syllables
                    .where((syllable) => !formedWord.contains(syllable))
                    .map((syllable) {
                  return Draggable<String>(
                      data: syllable,
                      feedback: Container(
                        width: 50,
                        height: 50,
                        color: Colors.blue.withOpacity(0.7),
                        alignment: Alignment.center,
                        child: Text(
                          syllable,
                        ),
                      ),
                      childWhenDragging: Container(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0,
                                  3), // Cambia la posición de la sombra (horizontal, vertical)
                            ),
                          ],
                        ),
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          syllable,
                        ),
                      ));
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
                child: const Text('Reinicar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
