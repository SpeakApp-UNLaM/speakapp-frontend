import 'package:flutter/material.dart';
import 'package:sp_front/presentations/screens/pending_screen.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AudioRecorderApp());
}

class AudioRecorderApp extends StatelessWidget {
  const AudioRecorderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => RecorderProvider())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:
              ThemeData(colorSchemeSeed: Colors.blueAccent, useMaterial3: true),
          home: const PendingScreen(),
        ));
  }
}
