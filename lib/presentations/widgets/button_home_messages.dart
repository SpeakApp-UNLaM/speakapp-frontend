import 'package:flutter/material.dart';

class ButtonHomeMessages extends StatelessWidget {
  const ButtonHomeMessages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0, // Ancho personalizado
      height: 100.0, // Alto personalizado
      child: FloatingActionButton(
        heroTag: 'messages_screen',
        onPressed: () {
          Navigator.pushNamed(context, '/messages_screen');

          // Acción al presionar el botón
        },

        elevation: 23.0,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.mail, size: 50), Text("Mensajes")],
        ),
        // Otras propiedades del FloatingActionButton
      ),
    );
  }
}
