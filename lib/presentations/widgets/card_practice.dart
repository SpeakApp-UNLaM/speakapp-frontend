import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/presentations/screens/exercise_screen.dart';

import '../../domain/entities/exercise.dart';

class Nivel {
  final String nombre;
  final List<String> categorias;
  Nivel(this.nombre, this.categorias);
}

class CardPractice extends StatelessWidget {
  CardPractice({super.key, required this.idPhoneme, required this.namePhoneme});
  List<Nivel> lvlAssigned = [];
  int idPhoneme;
  String namePhoneme;
  void _getData() {
    //TODO: GET [LEVEL X CATEGORY] DEL PHONEME
    lvlAssigned.add(Nivel('Nivel 1', ['Silabas']));
    lvlAssigned.add(Nivel('Nivel 2', ['Silabas', 'Palabras']));
  }

  @override
  Widget build(BuildContext context) {
    _getData();
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
              itemCount: lvlAssigned.length,
              itemBuilder: (context, index) {
                final asignacion = lvlAssigned[index];
                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          asignacion.nombre,
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600)),
                        ),
                        subtitle: Text(asignacion.categorias.join(', '),
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                  color: Colors.grey.shade500))),
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
                            //TODO: CREAR COMPONENTES PARA INGRESAR A LA LISTA DE EJERCICIOS
                            //TODO: TENGO QUE TRAER LA LISTA DE EJERCICIOS PARA EL NIVEL CATEGORIA Y PONEMA ASIGNADO
                            /*await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseScreen(
                                      idPhoneme: idPhoneme,
                                      namePhoneme: namePhoneme,
                                      level: asignacion.nombre,
                                      categorias: asignacion.categorias),
                                )); */
                            context.go(
                                "/exercise/$idPhoneme/$namePhoneme/${asignacion.nombre}/${asignacion.categorias.join(', ')}/");
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
