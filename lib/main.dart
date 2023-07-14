import 'package:flutter/material.dart';
import 'package:sp_front/config/routers/app_router.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';
import 'config/helpers/api.dart';

void main() {
  Api.configureDio();
  runApp(const AudioRecorderApp());
}

class AudioRecorderApp extends StatelessWidget {
  const AudioRecorderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => RecorderProvider())],
        child: MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          theme:
               ThemeData(
                 colorScheme: const ColorScheme.light(
                  primary:  Color(0xFF91e4fb),
                  secondary:Color(0xFFffc957),
                  tertiary: Color(0xFFd7eb5a)
                ),
                scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
                textTheme: const TextTheme(
                  displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)
                ),
                useMaterial3: true),
                
        ));
  }
}
