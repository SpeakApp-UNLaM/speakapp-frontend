import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/config/theme/app_theme.dart';
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
              decoration:  BoxDecoration(
                color: colorList[4],
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
              color: colorList[4],
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
              backgroundColor: colorList[4],
              elevation: 23.0,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 70,
                    color: colorList[5],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                 Text("Turnos",
                      style: TextStyle(
                        fontSize: 18,
                        color: colorList[5],
                        fontFamily: 'IkkaRounded',
                      ))
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
