import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List<String> _selectedValue3 = [];

  List<String> _typeOptions = [];
  List<String> _levelOptions = ['1', '2', '3'];

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
    print("HOLAAAAAAAAAAAAAAAAAAAAAAAA");
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
                Text(
                 "Seleccione categoría, tipo y nivel del grupo de ejercicios para el fónema:", 
                 textAlign: TextAlign.center,
                 style: GoogleFonts.nunito(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                 ),             
                ),
                Text(
                  widget.phoneme.namePhoneme,
                  style: GoogleFonts.nunito(
                      fontSize: 32,
                      color: colorList[1],
                      fontWeight: FontWeight.w800),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MultiSelectDropDown(
                        hint: 'Categoría',
                        onOptionSelected: (newValue) {
                          setState(() {
                            _selectedValue1 = [];
                            (newValue).forEach((element) {
                              _selectedValue1.add(element.value as String);
                              _typeOptions = [...?optionsMap[element.value]];
                            });
                          });
                        },
                        options: Categories.values
                            .map((category) => ValueItem(
                                value: category.toString().split('.').last,
                                label: Param.categoriesDescriptions[category]
                                    .toString()))
                            .toList(),
                        selectionType: SelectionType.multi,
                        chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                        dropdownHeight: 400,
                        optionTextStyle: const TextStyle(fontSize: 16),
                        selectedOptionIcon: const Icon(Icons.check_circle),
                      ),
                      const SizedBox(height: 50.0),
                      MultiSelectDropDown(
                        hint: 'Tipo Ejercicio',
                        onOptionSelected: (newValue) {
                          setState(() {
                            _selectedValue2 = [];
                            (newValue).forEach((element) {
                              _selectedValue2.add(element.value as String);
                            });
                          });
                        },
                        options: _typeOptions
                            .map((tipo) => ValueItem(
                                label: Param.typeExercisesDescription[tipo]
                                    as String,
                                value: tipo.toString()))
                            .toList(),
                        selectionType: SelectionType.multi,
                        chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                        dropdownHeight: 400,
                        optionTextStyle: const TextStyle(fontSize: 16),
                        selectedOptionIcon: const Icon(Icons.check_circle),
                      ),
                      const SizedBox(height: 50.0),
                      MultiSelectDropDown(
                        hint: 'Nivel Ejercicio',
                        onOptionSelected: (newValue) {
                          setState(() {
                            _selectedValue3 = [];
                            (newValue).forEach((element) {
                              _selectedValue3.add(element.value as String);
                            });
                          });
                        },
                        options: _levelOptions
                            .map((level) => ValueItem(
                                label: level.toString(),
                                value: level.toString()))
                            .toList(),
                        selectionType: SelectionType.multi,
                        chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                        dropdownHeight: 400,
                        optionTextStyle: const TextStyle(fontSize: 16),
                        selectedOptionIcon: const Icon(Icons.check_circle),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  child: FilledButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            colorList[4], // Cambia el color de fondo aquí
                      ),
                      onPressed: () {
                        if (_selectedValue1.isNotEmpty &&
                            _selectedValue2.isNotEmpty &&
                            _selectedValue3.isNotEmpty) {
                          context.push(
                            "/exercise_specialist",
                            extra: {
                              'typesExercise': _selectedValue2,
                              'idsPhoneme': widget.phoneme.idPhoneme,
                              'categories': _selectedValue1,
                              'levels': _selectedValue3,
                              'namePhoneme': widget.phoneme.namePhoneme
                            },
                          );

                          textEditingController1.clear();
                          textEditingController2.clear();
                        } else {
                          Fluttertoast.showToast(
                            msg:
                                'Existen campos incompletos', // Mensaje de la excepción
                            toastLength: Toast
                                .LENGTH_LONG, // Duración del toast (Toast.LENGTH_LONG o Toast.LENGTH_SHORT)
                            gravity: ToastGravity
                                .CENTER, // Posición del toast (ToastGravity.TOP, ToastGravity.CENTER, ToastGravity.BOTTOM)
                            backgroundColor:
                                Colors.amberAccent, // Color de fondo del toast
                            textColor:
                                Colors.white, // Color del texto del toast
                          );
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
