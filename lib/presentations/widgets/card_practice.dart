import 'package:flutter/material.dart';
import 'package:sp_front/config/theme/app_theme.dart';

class Nivel {
  final String nombre;
  final List<String> categorias;
  Nivel(this.nombre, this.categorias);
}

class CardPractice extends StatelessWidget {
  CardPractice({super.key, required this.idPhoneme});
  List<Nivel> lvlAssigned = [];
  int idPhoneme = 0;
  void _getData() {
    //TODO: GET [LEVEL X CATEGORY] DEL PHONEME
    lvlAssigned.add(Nivel('Nivel 1', ['Categoria A', 'Categoria B']));
    lvlAssigned.add(Nivel('Nivel 2', ['Categoria C', 'Categoria D']));
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
                    fontFamily: "IkkaRounded"
                  ),
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
                        title: Text(asignacion.nombre),
                        subtitle: Text(asignacion.categorias.join(', ')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FilledButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorList[4], // Cambia el color de fondo aquí
                          ),
                          onPressed: () {
                            // Acción del botón
                            // Puedes agregar aquí la lógica que deseas ejecutar cuando se presiona el botón
                          },
                          child: Text(
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
