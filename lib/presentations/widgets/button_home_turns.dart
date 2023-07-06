import 'package:flutter/material.dart';

class ButtonTurns extends StatelessWidget {
  const ButtonTurns({
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
          Navigator.pushNamed(context, '/turns_screen');

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
