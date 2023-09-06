import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_theme.dart';
import '../../domain/entities/level.dart';
import '../widgets/card_articulation.dart';
import '../widgets/card_practice.dart';

class ChoiceExerciseScreen extends StatelessWidget {
  final int phoneme;
  final String namePhoneme;
  final List<Level> levels;
  const ChoiceExerciseScreen(
      {super.key,
      required this.phoneme,
      required this.namePhoneme,
      required this.levels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: colorList[7],
        toolbarHeight: 80,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('¿Estas listo?',
                style: TextStyle(
                    fontSize: 21,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'IkkaRounded',
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 10),
            Text('Seleccione una práctica para comenzar:',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          //CardArticulation(),
          CardPractice(
              idPhoneme: phoneme,
              namePhoneme: namePhoneme,
              levels: levels) //creo que son todos ejercicios ahora no?
        ]),
      ),
    );
  }
}
