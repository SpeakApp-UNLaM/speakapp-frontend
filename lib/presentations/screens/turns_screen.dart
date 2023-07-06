import 'package:flutter/material.dart';

class TurnsScreen extends StatelessWidget {
  const TurnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turnos'),
      ),
      body: Center(
        child: Text(
          'Contenido de la Turnos',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
