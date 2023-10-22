import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_front/auth/user_preferences.dart';
import 'package:sp_front/config/routers/app_router.dart';
import 'package:sp_front/providers/auth_provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:sp_front/providers/login_provider.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';
import 'config/helpers/api.dart';
import 'config/theme/app_theme.dart';

Future<void> main() async {
  Api.configureDio();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  final state = AuthProvider(await SharedPreferences.getInstance());
  /*await UserPreferences().removeUser();
  exit(1);*/
  FlutterNativeSplash.remove();
  await state.checkLoggedIn();

  runApp(AudioRecorderApp(authProvider: state));
}

class AudioRecorderApp extends StatelessWidget {
  final AuthProvider authProvider;

  const AudioRecorderApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            lazy: false, create: (BuildContext createContext) => authProvider),
        ChangeNotifierProvider(create: (_) => RecorderProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        Provider<AppRouter>(
          lazy: false,
          create: (BuildContext createContext) => AppRouter(authProvider),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final router = Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es', 'ES'),
            ],
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme(context),
          );
        },
      ),
    );
  }
}
