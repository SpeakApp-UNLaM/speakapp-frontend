import 'package:flutter/material.dart';
import '../widgets/card_articulation.dart';
import '../widgets/card_practice.dart';

class ChoiceExerciseScreen extends StatelessWidget {
  final int phoneme;
  final String namePhoneme;
  const ChoiceExerciseScreen(
      {super.key, required this.phoneme, required this.namePhoneme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practicas'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('RR'),
          const SizedBox(
            height: 10,
          ),
          const Text("Seleccione una práctica para comenzar"),
          const SizedBox(
            height: 10,
          ),
          const CardArticulation(),
          CardPractice(
            idPhoneme: phoneme,
            namePhoneme: namePhoneme,
          )
        ],
      ),
    );
  }
}
