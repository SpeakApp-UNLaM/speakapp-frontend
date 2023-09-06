import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_theme.dart';
import '../../domain/entities/level.dart';
import '../../providers/recorder_provider.dart';
import '../screens/choice_exercise_screen.dart';

class ButtonPhoneme extends StatelessWidget {
  final int idPhoneme;
  final String namePhoneme;
  final String tag;
  final List<Level> levels;
  const ButtonPhoneme(
      {super.key,
      required this.idPhoneme,
      required this.namePhoneme,
      required this.tag,
      required this.levels});

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
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
          Container(
            height: 135,
            width: 114,
            decoration: BoxDecoration(
              color: colorList[0],
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: FloatingActionButton(
              heroTag: tag,
              onPressed: () async {
                recorderProv.resetAudio();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChoiceExerciseScreen(
                          phoneme: idPhoneme,
                          namePhoneme: namePhoneme,
                          levels: levels),
                    ));
                //context.push('/choice_exercise/$codeGroup/$name');
              },
              backgroundColor: colorList[0],
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(namePhoneme.toUpperCase(),
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
  }
}
