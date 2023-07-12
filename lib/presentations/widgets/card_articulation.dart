import 'package:flutter/material.dart';

class CardArticulation extends StatelessWidget {
  const CardArticulation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                color: const Color.fromARGB(255, 255, 195, 106),
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(23),
              child: const Center(
                child: Text(
                  'Articulemas',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 207, 100, 13),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Elemento ${index + 1}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
