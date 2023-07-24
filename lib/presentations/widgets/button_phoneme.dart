import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/presentations/screens/choice_exercise_screen.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/recorder_provider.dart';

class ButtonPhoneme extends StatelessWidget {
  final int codeGroup;
  final String name;
  final String tag;

  const ButtonPhoneme({super.key, required this.codeGroup, required this.name, required this.tag});

  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    return SizedBox(
      height: 140.0,
      width: 120.0,
      // Ancho personalizado
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 136,
              width: 116,
              decoration: BoxDecoration(
                color: colorList[1],
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
          Container(
            height: 136,
            width: 116,
            decoration: BoxDecoration(
              color: colorList[0],
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: FloatingActionButton(
              heroTag: tag,
              onPressed: () async {
                recorderProv.resetAudio();
                final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ChoiceExerciseScreen(phoneme: 1),
                    ));
              },
              backgroundColor: colorList[0],
              elevation: 23.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 36,
                        color: colorList[2],
                        fontFamily: 'IkkaRounded',
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return ElevatedButton(
      onPressed: () async {
        recorderProv.resetAudio();
        final resultado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChoiceExerciseScreen(phoneme: 1),
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
