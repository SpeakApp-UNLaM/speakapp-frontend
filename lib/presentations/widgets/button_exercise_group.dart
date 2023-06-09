import 'package:flutter/material.dart';
import '../screens/exercises_pending_screen.dart';

class ButtonExerciseGroup extends StatelessWidget {
  final int codeGroup;
  final String name;

  const ButtonExerciseGroup(
      {super.key, required this.codeGroup, required this.name});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PageViewScreen(codeGroupExercise: codeGroup)),
        );
      },
      child: Text(name.toUpperCase(), style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),),
    );
  }
}
