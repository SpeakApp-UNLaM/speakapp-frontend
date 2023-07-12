import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_front/presentations/screens/views/phoneme_view.dart';

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
        onPressed: () {
          // Acción al presionar el botón
          context.pushNamed(PhonemeView.name);
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
