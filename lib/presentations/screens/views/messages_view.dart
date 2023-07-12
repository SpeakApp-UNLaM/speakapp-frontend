import 'package:flutter/material.dart';

class MessagesView extends StatelessWidget {
  static const String name = 'messages';

  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla messages'),
      ),
      body: const Center(
        child: Text(
          'Contenido de la messages',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
