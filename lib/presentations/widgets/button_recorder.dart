import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';

import '../../config/theme/app_theme.dart';
import '../../providers/recorder_provider.dart';

class ButtonRecorder extends StatelessWidget {
  const ButtonRecorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    final exerciseProv = context.watch<ExerciseProvider>();

    return GestureDetector(
        onTapUp: (details) async {
          await recorderProv.stopRecording();
          if (recorderProv.existAudio) {
            exerciseProv.finishExercise();
          }
        },
        onTapDown: (details) async => await recorderProv.startRecording(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCirc,
          decoration: BoxDecoration(
            color: recorderProv.recordingOn ? Colors.grey[400] : colorList[4],
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
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mic,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(width: 8.0),
              Text(
                recorderProv.recordingOn ? '...' : 'Grabar',
                style: GoogleFonts.nunitoSans(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          ),
        ));
  }
}
