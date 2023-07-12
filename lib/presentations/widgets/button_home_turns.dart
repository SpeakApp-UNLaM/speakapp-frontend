import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_front/presentations/screens/views/turns_view.dart';

class ButtonHomeTurns extends StatelessWidget {
  const ButtonHomeTurns({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0, // Ancho personalizado
      height: 100.0, // Alto personalizado
      child: FloatingActionButton(
        heroTag: 'turns_screen',
        onPressed: () {
          context.pushNamed(TurnsView.name);

          // Acción al presionar el botón
        },

        elevation: 23.0,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.access_time_sharp, size: 50), Text("Turnos")],
        ),
        // Otras propiedades del FloatingActionButton
      ),
    );
  }
}
