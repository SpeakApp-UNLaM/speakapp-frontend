import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/config/theme/app_theme.dart';

import '../../config/helpers/param.dart';
import '../../domain/entities/level.dart';
import '../screens/exercise_screen.dart';

class CardPractice extends StatelessWidget {
  final List<Level> levels;
  final int idPhoneme;
  final String namePhoneme;

  const CardPractice(
      {super.key,
      required this.idPhoneme,
      required this.namePhoneme,
      required this.levels});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context)
          .size
          .width, // Ocupa todo el ancho de la pantalla
      margin: const EdgeInsets.all(30.0),
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 6,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorList[0],
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(23),
              child: Center(
                child: Text(
                  'Practicas',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: colorList[2],
                      fontWeight: FontWeight.bold,
                      fontFamily: "IkkaRounded"),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final asignacion = levels[index];
                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          "Nivel ${asignacion.value}",
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600)),
                        ),
                        subtitle: Text(
                            "" +
                                asignacion.categories
                                    .map((category) =>
                                        Param.categoriesDescriptions[category])
                                    .toList()
                                    .join(', '),
                            style: GoogleFonts.nunito(
                                textStyle:
                                    TextStyle(color: Colors.grey.shade500))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FilledButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                colorList[4], // Cambia el color de fondo aquí
                          ),
                          onPressed: () async {
                            ExerciseParameters params = ExerciseParameters(
                                idPhoneme: idPhoneme,
                                namePhoneme: namePhoneme,
                                level: levels[index].value,
                                categories: levels[index].categories);

                            context.push("/exercise", extra: params);
                            // Acción del botón
                            // Puedes agregar aquí la lógica que deseas ejecutar cuando se presiona el botón
                          },
                          child: const Text(
                            "Comenzar",
                            style: TextStyle(
                              fontFamily: 'IkkaRounded',
                            ),
                          )),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
