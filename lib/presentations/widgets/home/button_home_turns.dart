import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              decoration: BoxDecoration(
                color: colorList[4],
                borderRadius: const BorderRadius.all(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 70,
                    color: colorList[5],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Turnos", style: Theme.of(context).textTheme.bodyMedium)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
