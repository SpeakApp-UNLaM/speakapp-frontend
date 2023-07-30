import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/card_articulation.dart';
import '../widgets/card_practice.dart';

class ChoiceExerciseScreen extends StatelessWidget {
  final int phoneme;
  const ChoiceExerciseScreen({super.key, required this.phoneme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          leading: const BackButton(
            color: Color(0xFFF5F5F5),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
          toolbarHeight: 80,
          title:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('¿Estas listo?',
                style: TextStyle(
                    fontSize: 21,
                    color: Color(0xFFF5F5F5),
                    fontFamily: 'IkkaRounded',
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 10),
            Text('Seleccione una práctica para comenzar:',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Color(0xFFF5F5F5),
                ))
          ],
        ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Column(children: [
          //CardArticulation(), creo que son todos ejercicios ahora no?
          CardPractice(
            idPhoneme: phoneme,
          )
        ]),
      ),
    );
  }
}
