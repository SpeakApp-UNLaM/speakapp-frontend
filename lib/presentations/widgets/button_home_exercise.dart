import 'package:flutter/material.dart';

class ButtonHomeExercise extends StatelessWidget {
  const ButtonHomeExercise({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0, // Ancho personalizado
      height: 100.0, // Alto personalizado
      child: FloatingActionButton(
        heroTag: 'exercises_pending_screen',
        onPressed: () {
          // Acción al presionar el botón
          Navigator.pushNamed(context, '/exercises_pending_screen');
        },

        elevation: 23.0,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_time_extension_outlined, size: 50),
            Text("Ejercicios")
          ],
        ),
        // Otras propiedades del FloatingActionButton
      ),
    );
  }
}
