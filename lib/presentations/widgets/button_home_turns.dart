import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/presentations/screens/views/turns_view.dart';

class ButtonHomeTurns extends StatelessWidget {
  const ButtonHomeTurns({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
      return SizedBox(
      height: 180.0,
      width: 140.0,
      // Ancho personalizado
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 176,
              width: 136,
              decoration: const BoxDecoration(
                color: Color(0xFF00c8f8),
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
          Container(
            height: 176,
            width: 136,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: FloatingActionButton(
              heroTag: 'turns_screen',
              onPressed: () {
                // Acción al presionar el botón
                context.pushNamed(TurnsView.name);
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 23.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 70,
                    color: Color(0xFF008db1),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Turnos",
                    style: GoogleFonts.nunitoSans(
                      textStyle: const TextStyle(
                        color: Color(0xFF008db1),
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ) 
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return SizedBox(
      width: 140.0, // Ancho personalizado
      height: 180.0, // Alto personalizado
      child: FloatingActionButton(
        heroTag: 'turns_screen',
        onPressed: () {
          context.pushNamed(TurnsView.name);

          // Acción al presionar el botón
        },
        elevation: 23.0,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(Icons.calendar_month, size: 70, color: Color(0xFF008db1)),
          Text("Turnos",  style: TextStyle(
                color: Color(0xFF008db1),
                fontWeight: FontWeight.w600,
                fontSize: 18
              ))
          ],
        ),
        // Otras propiedades del FloatingActionButton
      ),
    );
  }
}
