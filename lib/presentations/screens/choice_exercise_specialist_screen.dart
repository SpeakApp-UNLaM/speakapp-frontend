import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/phoneme.dart';

class ChoiceExerciseSpecialistScreen extends StatefulWidget {
  final Phoneme phoneme;
  const ChoiceExerciseSpecialistScreen({super.key, required this.phoneme});

  @override
  ChoiceExerciseSpecialistScreenState createState() =>
      ChoiceExerciseSpecialistScreenState();
}

class ChoiceExerciseSpecialistScreenState
    extends State<ChoiceExerciseSpecialistScreen> {
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
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  context.push("/exercise_specialist", extra: {
                    'typesExercise': selectedValue2,
                    'idsPhoneme': widget.phoneme.idPhoneme,
                    'categories': selectedValue1,
                    'levels': nivel,
                  });

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
