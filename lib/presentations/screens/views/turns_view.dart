import 'package:flutter/material.dart';

class TurnsView extends StatelessWidget {
  static const String name = 'turns';

  const TurnsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turnos'),
      ),
      body: Center(
        child: Text(
          'Contenido de la Turnos',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
