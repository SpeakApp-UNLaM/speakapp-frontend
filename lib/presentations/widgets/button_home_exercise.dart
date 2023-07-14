import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/presentations/screens/views/phoneme_view.dart';

class ButtonHomeExercise extends StatelessWidget {
  const ButtonHomeExercise({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      width: 300,
      // Ancho personalizado
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 146,
              width: 295,
              decoration: const BoxDecoration(
                color: Color(0xFFffa834),
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
          Container(
            height: 146,
            width: 295,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: FloatingActionButton(
              heroTag: 'exercise_screen',
              onPressed: () {
                // Acción al presionar el botón
                context.pushNamed(PhonemeView.name);
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 23.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.extension,
                    size: 70,
                    color: Color(0xFFff8351),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Practicas",
                    style: GoogleFonts.nunitoSans(
                        textStyle: const TextStyle(
                            color: Color(0xFFff8351),
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
