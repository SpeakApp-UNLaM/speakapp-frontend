import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import '../../config/helpers/param.dart';
import '../../domain/entities/category.dart';
import '../screens/exercise_screen.dart';

class CardPractice extends StatelessWidget {
  final List<Category> categories;
  final int idPhoneme;
  final String namePhoneme;

  const CardPractice(
      {super.key,
      required this.idPhoneme,
      required this.namePhoneme,
      required this.categories});

  @override
  Widget build(BuildContext context) {
    final nivelMap = <int, List<Categories>>{};
    for (final item in categories) {
      final categoryModel = item;
      nivelMap
          .putIfAbsent(categoryModel.level, () => [])
          .add(categoryModel.category);
    }
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(30.0),
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
              itemCount: categories.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                int desafio = index + 1;
                int nivel = categories.elementAt(index).level;
                int idTask = categories.elementAt(index).idTask;
                late final categorias;
                if (nivelMap.containsKey(nivel)) {
                  categorias = nivelMap[
                      nivel]; // Acceder al valor usando la clave como índice
                } else {}

                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          "Desafio $desafio",
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600)),
                        ),
                        subtitle: Text(
                            "Nivel $nivel: ${formatCategories(categorias)}",
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
                                level: nivel,
                                idTask: idTask,
                                categories: categorias);

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

  String formatCategories(categorias) {
    Set<dynamic> categoriasSinDuplicados = categorias
        .map((category) => Param.categoriesDescriptions[category])
        .toSet();

    return categoriasSinDuplicados.join(', ');
  }
}
