import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recorder_provider.dart';
import '../screens/exercises_pending_screen.dart';

class ButtonExerciseGroup extends StatelessWidget {
  final int codeGroup;
  final String name;

  const ButtonExerciseGroup(
      {super.key, required this.codeGroup, required this.name});

  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    return ElevatedButton(
      onPressed: () async {
        recorderProv.resetAudio();
        final resultado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ExercisePendingScreen(codeGroupExercise: codeGroup),
          ),
        );
        if (resultado == 'fin_grupo') {
          //TODO: Logica para actualizar listas de grupos de ejercicios
        }
      },
      child: Text(
        name.toUpperCase(),
        style: const TextStyle(
            fontFamily: 'Fixed', fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }
}
