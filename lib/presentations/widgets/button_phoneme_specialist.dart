import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_theme.dart';
import '../../domain/entities/phoneme.dart';

class ButtonPhonemeSpecialist extends StatelessWidget {
  final String tag;
  final Phoneme phoneme;
  const ButtonPhonemeSpecialist(
      {super.key, required this.tag, required this.phoneme});

  @override
  Widget build(BuildContext context) {
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
                context.push("/choice_exercise_specialist", extra: phoneme);
              },
              backgroundColor: colorList[0],
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(phoneme.namePhoneme.toUpperCase().split(" ")[0],
                      style: GoogleFonts.nunito(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: colorList[2])),
                  if (phoneme.namePhoneme.toUpperCase().split(" ").length > 1)
                    Text(
                      phoneme.namePhoneme.toUpperCase().split(" ")[1],
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
