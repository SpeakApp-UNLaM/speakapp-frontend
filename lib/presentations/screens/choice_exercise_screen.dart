import 'package:flutter/material.dart';
import '../widgets/card_articulation.dart';
import '../widgets/card_practice.dart';

class ChoiceExerciseScreen extends StatelessWidget {
  final int phoneme;
  const ChoiceExerciseScreen({super.key, required this.phoneme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Practicas'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('RR'),
            SizedBox(
              height: 10,
            ),
            Text("Seleccione una práctica para comenzar"),
            SizedBox(
              height: 10,
            ),
            CardArticulation(),
            CardPractice(
              idPhoneme: phoneme,
            )
          ],
        ),
      );
  }
}
