/*import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_front/config/routers/app_router.dart';
import 'package:sp_front/providers/auth_provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:sp_front/providers/login_provider.dart';
import 'package:sp_front/providers/recorder_provider.dart';
import 'package:provider/provider.dart';
import 'auth/user_preferences.dart';
import 'config/helpers/api.dart';
import 'config/theme/app_theme.dart';

Future<void> main() async {
  Api.configureDio();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  FlutterNativeSplash.remove();
  runApp(AudioRecorderApp2());
}

class AudioRecorderApp2 extends StatelessWidget {
  const AudioRecorderApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecorderProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final router = Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme(),
          );
        },
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_front/presentations/screens/exercise_screen.dart';
import 'package:sp_front/providers/auth_provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:sp_front/providers/recorder_provider.dart';

import 'config/helpers/api.dart';
import 'config/helpers/param.dart';
import 'config/theme/app_theme.dart';

Future<void> main() async {
  Api.configureDio();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  final state = AuthProvider(await SharedPreferences.getInstance());
  FlutterNativeSplash.remove();

  runApp(MyApp(authProvider: state));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
              lazy: false,
              create: (BuildContext createContext) => authProvider),
          ChangeNotifierProvider(create: (_) => RecorderProvider()),
          ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ],
        child: MaterialApp(
            title: 'TEST EXERCISES',
            theme: AppTheme.theme(context),
            debugShowCheckedModeBanner: false,
            home: const MyHomePage()));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyForm();
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String selectedValue1 = 'syllable';
  String selectedValue2 = 'speak';
  Map<String, List<String>> optionsMap = {
    'syllable': [
      'speak',
      'multiple_selection',
      'single_selection_syllable',
      'order_syllable',
      'consonantal_syllable',
    ],
    'word': [
      'multiple_match_selection',
      'minimum_pairs_selection',
      'single_selection_word',
    ],
    'phrase': [
      'speak',
      'multiple_match_selection',
      'minimum_pairs_selection',
      'multiple_selection',
      'single_selection_syllable',
      'order_syllable',
      'single_selection_word',
      'consonantal_syllable',
    ]
  };
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tester Exercises'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            DropdownButton<String>(
              value: selectedValue1,
              onChanged: (newValue) {
                setState(() {
                  selectedValue1 = newValue!;
                  selectedValue2 = optionsMap[selectedValue1]!.first;
                });
              },
              items: <String>['syllable', 'word', 'phrase']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              style: Theme.of(context).textTheme.titleMedium,
              validator: (value) {
                if (value == null || value.isEmpty || value == '') {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              controller: textEditingController1,
              decoration: InputDecoration(
                label: Text(
                  'Ingrese ID del fonema. Utilizar separador ; para mas de un fonema',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButton<String>(
              value: selectedValue2,
              onChanged: (newValue) {
                setState(() {
                  selectedValue2 = newValue!;
                });
              },
              items: optionsMap[selectedValue1]
                  ?.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value == '') {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              controller: textEditingController2,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                  floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
                  label: Text(
                    'Ingrese el nivel. Utilizar separador ; para mas de un nivel',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  suffixStyle: Theme.of(context).textTheme.titleSmall),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  List<int> nivel = textEditingController2.text
                      .split(';')
                      .map((str) => int.parse(str))
                      .toList();
                  List<String> phonemes =
                      textEditingController1.text.split(';');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExerciseScreen(
                                object: ExerciseParameters(
                                    idPhoneme: int.parse(phonemes.first),
                                    namePhoneme: "",
                                    idTask: 1,
                                    categories: [
                                      Param.stringToEnumCategories(
                                          selectedValue1)
                                    ],
                                    level: 1),
                                queryParameters: {
                                  'typesExercise': selectedValue2,
                                  'idsPhoneme': phonemes,
                                  'categories': selectedValue1,
                                  'levels': nivel,
                                },
                              )));

                  textEditingController1.clear();
                  textEditingController2.clear();
                }
              },
              child: const Text('Comenzar'),
            ),
          ]),
        ),
      ),
    );
  }
}
