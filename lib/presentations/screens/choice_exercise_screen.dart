import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../domain/entities/task.dart';
import '../widgets/card_practice.dart';

class ChoiceExerciseScreenParameters {
  final int phoneme;
  final String namePhoneme;
  //final List<Level> levels;

  ChoiceExerciseScreenParameters(
      {required this.phoneme, required this.namePhoneme});
}

class ChoiceExerciseScreen extends StatelessWidget {
  final Task object;

  const ChoiceExerciseScreen({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: colorList[7],
        toolbarHeight: 80,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('¿Estás listo?',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Text('Seleccione una práctica para comenzar:',
                style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          //CardArticulation(),
          CardPractice(
              idPhoneme: object.phoneme.idPhoneme,
              namePhoneme: object.phoneme.namePhoneme,
              categories: object.categories)
        ]),
      ),
    );
  }
}
