import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';

import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
import '../../domain/entities/result_exercise.dart';
import '../../providers/recorder_provider.dart';

class ButtonRecorder extends StatelessWidget {
  final int idExercise;
  const ButtonRecorder({Key? key, required this.idExercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    final exerciseProv = context.watch<ExerciseProvider>();

    return Column(
      children: [
        GestureDetector(
            onTapUp: (details) async {
              await recorderProv.stopRecording();
              if (recorderProv.existAudio) {
                String audioInBase64 =
                    await recorderProv.convertAudioToBase64();

                exerciseProv.saveParcialResult(ResultExercise(
                    idTaskItem: idExercise,
                    type: TypeExercise.speak,
                    audio: audioInBase64,
                    pairImagesResult: []));
                //exerciseProv.finishExercise();
              }
            },
            onTapDown: (details) async => await recorderProv.startRecording(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCirc,
              decoration: BoxDecoration(
                color:
                    recorderProv.recordingOn ? Colors.grey[400] : colorList[4],
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  if (recorderProv.recordingOn)
                    BoxShadow(
                      color: Colors.grey[400]!,
                      offset: const Offset(0, 2),
                      blurRadius: 2.0,
                    ),
                ],
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 10,
        ),
        Text(
          recorderProv.recordingOn ? '...' : 'Manten presionado para grabar',
          style: GoogleFonts.nunito(
              color: colorList[4], fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
