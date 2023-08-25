import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sp_front/config/routers/app_router.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';
import 'config/helpers/api.dart';
import 'config/theme/app_theme.dart';

void main() {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  Api.configureDio();
  runApp(const AudioRecorderApp());
  FlutterNativeSplash.remove();
}

class AudioRecorderApp extends StatelessWidget {
  const AudioRecorderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => RecorderProvider()), ChangeNotifierProvider(create: (_) => ExerciseProvider())],
        child: MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme(),
                
        ));
  }
}
