import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/config/helpers/param.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/providers/auth_provider.dart';
import 'package:sp_front/shared/custom_dropdown_button.dart';
import 'package:sp_front/shared/custom_text_form_field.dart';
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
  List<String> _selectedValue1 = [];
  List<String> _selectedValue2 = [];

  String selectedValue1 = 'syllable';

  String selectedValue2 = 'speak';

  Map<String, List<String>> optionsMap = {
    'syllable': [
      'speak',
      'multiple_selection',
      'single_selection_syllable',
      'consonantal_syllable',
    ],
    'word': [
      'order_syllable',
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
    final authProvider = context.watch<AuthProvider>();
    List<int> nivelList = [];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      'Volver',
                      style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /*
                    MultiSelectDropDown(
                      hint: 'Categoría',
                      onOptionSelected: (newValue) {
                        setState(() {
                          (newValue).forEach((element) {
                            _selectedValue1.add(element.value as String);
                            _selectedValue2 = [
                              optionsMap[element.value as String]!.first
                            ];
                          });
                        });
                      },
                      options: Categories.values
                          .map((category) => ValueItem(
                              value: category.toString().split('.').last,
                              label: category.toString().split('.').last))
                          .toList(),
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                     MultiSelectDropDown(
                      hint: 'Categoría',
                      onOptionSelected: (newValue) {
                        setState(() {
                          (newValue).forEach((element) {
                            _selectedValue1.add(element.value as String);
                            _selectedValue2 = [
                              optionsMap[element.value as String]!.first
                            ];
                          });
                        });
                      },
                      options: Categories.values
                          .map((category) => ValueItem(
                              value: category.toString().split('.').last,
                              label: category.toString().split('.').last))
                          .toList(),
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),*/
                    CustomDropdownButton(
                        value: selectedValue1,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue1 = newValue as String;
                            selectedValue2 = optionsMap[selectedValue1]!.first;
                          });
                        },
                        options: Categories.values
                            .map((category) =>
                                category.toString().split('.').last)
                            .toList(),
                        errorMessage: null,
                        label: 'Tipo'),
                    const SizedBox(height: 30.0),
                    CustomDropdownButton(
                        value: selectedValue2,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue2 = newValue as String;
                          });
                        },
                        options: optionsMap[selectedValue1],
                        errorMessage: null,
                        label: 'Tipo'),
                    const SizedBox(height: 30.0),
                    CustomTextFormField(
                      textEditingController: textEditingController1,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == '') {
                          return 'Este campo es obligatorio';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        nivelList = value
                            .split(';')
                            .map((str) => int.parse(str))
                            .toList();
                      },
                      label: 'Nivel',
                      hint: 'Utilizar separador ; para mas de un nivel',
                      obscureText: false,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FilledButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            colorList[4], // Cambia el color de fondo aquí
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> extras = {
                            'typesExercise': selectedValue2,
                            'idsPhoneme': widget.phoneme.idPhoneme,
                            'categories': selectedValue1,
                            'levels': nivelList,
                          };
                          textEditingController1.clear();
                          textEditingController2.clear();
                          context.push("/exercise_specialist", extra: extras);
                        }
                      },
                      child: Text(
                        "Comenzar",
                        style: Theme.of(context).textTheme.labelSmall,
                      )),
                ),
              ]),
        ),
      ),
    );
  }
}
