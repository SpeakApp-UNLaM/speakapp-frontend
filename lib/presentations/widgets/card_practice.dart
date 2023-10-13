import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                  'Prácticas',
                  style: Theme.of(context).textTheme.displayMedium,
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

                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          Param.categoriesDescriptions[
                              categories.elementAt(index).category]!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text("Desafío $desafio: Nivel $nivel",
                            style: Theme.of(context).textTheme.titleSmall),
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
                                categories: [
                                  categories.elementAt(index).category
                                ]);

                            context.push("/exercise", extra: params);
                            // Acción del botón
                            // Puedes agregar aquí la lógica que deseas ejecutar cuando se presiona el botón
                          },
                          child: Text(
                            "Comenzar",
                            style: Theme.of(context).textTheme.labelSmall,
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

  /*String formatCategories(categorias) {
    Set<dynamic> categoriasSinDuplicados = categorias
        .map((category) => Param.categoriesDescriptions[category])
        .toSet();

    return categoriasSinDuplicados.join(', ');
  }*/
}
