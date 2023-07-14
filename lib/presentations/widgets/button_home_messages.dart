import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/presentations/screens/views/messages_view.dart';

class ButtonHomeMessages extends StatelessWidget {
  const ButtonHomeMessages({
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
                color: Color(0xFFc1d045),
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
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: FloatingActionButton(
              heroTag: 'message_screen',
              onPressed: () {
                // Acción al presionar el botón
                context.pushNamed(MessagesView.name);
              },
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              elevation: 23.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mail,
                    size: 70,
                    color: Color(0xFF72bb53),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Mensajes",
                    style: GoogleFonts.nunitoSans(
                        textStyle: const TextStyle(
                            color: Color(0xFF72bb53),
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
