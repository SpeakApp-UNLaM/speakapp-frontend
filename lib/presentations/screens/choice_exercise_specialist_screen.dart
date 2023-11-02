import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/config/helpers/api.dart';
import 'package:sp_front/config/helpers/param.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/domain/entities/category.dart';
import 'package:sp_front/providers/auth_provider.dart';
import 'package:sp_front/shared/custom_dropdown_button.dart';
import 'package:sp_front/shared/custom_text_form_field.dart';
import '../../domain/entities/phoneme.dart';

class PhonemeOption {
  Categories category;
  List<TypeExercise> typeExercises;
  List<int> levels;

  PhonemeOption({
    required this.category,
    required this.typeExercises,
    required this.levels,
  });

  factory PhonemeOption.fromJson(Map<String, dynamic> json) {
    return PhonemeOption(
      category: Param.stringToEnumCategories(json["category"]),
      typeExercises: (json["typeExercises"] as List<dynamic>?)
              ?.map((e) => Param.stringToEnumTypeExercise(e))
              .toList() ??
          [],
      levels:
          (json["levels"] as List<dynamic>?)?.map((e) => e as int).toList() ??
              [], // Valor predeterminado si es nulo
    );
  }
}

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
  List<String> _levelOptions = [];

  String selectedValue1 = 'syllable';

  String selectedValue2 = 'speak';
  List<PhonemeOption> phonemeOption = [];
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  Future? _fetchData;

  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  Future fetchData() async {
    final response = await Api.get(
        "${Param.getAvailablesPhonemes}/${widget.phoneme.idPhoneme}");
    if (response != null) {
      for (var element in response) {
        phonemeOption.add(PhonemeOption.fromJson(element));
      }
    }

    return response;
  }

  @override
  void initState() {
    _fetchData = fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _formKey,
          child: FutureBuilder(
              future: _fetchData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else {
                  return Column(
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
                              fontWeight: FontWeight.w600),
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
                                    _typeOptions = [];
                                    _levelOptions = [];
                                    (newValue).forEach((element) {
                                      _selectedValue1
                                          .add(element.value as String);
                                      List<TypeExercise> availableTypes =
                                          phonemeOption
                                              .where((e) =>
                                                  e.category.name ==
                                                  element.value)
                                              .last
                                              .typeExercises;
                                      List<int> availableLevels = phonemeOption
                                          .where((e) =>
                                              e.category.name == element.value)
                                          .last
                                          .levels;

                                      _typeOptions = <String>{
                                        ...availableTypes
                                            .map((e) => e.name)
                                            .toList(),
                                        ..._typeOptions
                                      }.toList();
                                      _levelOptions = <String>{
                                        ...availableLevels
                                            .map((e) => e.toString())
                                            .toList(),
                                        ..._levelOptions
                                      }.toList();
                                    });
                                  });
                                },
                                options: phonemeOption
                                    .map((e) => ValueItem(
                                        label: Param.categoriesDescriptions[
                                            e.category] as String,
                                        value: e.category.name))
                                    .toList(),
                                selectionType: SelectionType.multi,
                                chipConfig:
                                    const ChipConfig(wrapType: WrapType.scroll),
                                dropdownHeight: 400,
                                optionTextStyle: const TextStyle(fontSize: 16),
                                selectedOptionIcon:
                                    const Icon(Icons.check_circle),
                              ),
                              const SizedBox(height: 50.0),
                              MultiSelectDropDown(
                                hint: 'Tipo Ejercicio',
                                onOptionSelected: (newValue) {
                                  setState(() {
                                    _selectedValue2 = [];
                                    (newValue).forEach((element) {
                                      _selectedValue2
                                          .add(element.value as String);
                                    });
                                  });
                                },
                                options: _typeOptions
                                    .map((tipo) => ValueItem(
                                        label:
                                            Param.typeExercisesDescription[tipo]
                                                as String,
                                        value: tipo.toString()))
                                    .toList(),
                                selectionType: SelectionType.multi,
                                chipConfig:
                                    const ChipConfig(wrapType: WrapType.scroll),
                                dropdownHeight: 400,
                                optionTextStyle: const TextStyle(fontSize: 16),
                                selectedOptionIcon:
                                    const Icon(Icons.check_circle),
                              ),
                              const SizedBox(height: 50.0),
                              MultiSelectDropDown(
                                hint: 'Nivel Ejercicio',
                                onOptionSelected: (newValue) {
                                  setState(() {
                                    _selectedValue3 = [];
                                    (newValue).forEach((element) {
                                      _selectedValue3
                                          .add(element.value as String);
                                    });
                                  });
                                },
                                options: _levelOptions
                                    .map((level) => ValueItem(
                                        label: level.toString(),
                                        value: level.toString()))
                                    .toList(),
                                selectionType: SelectionType.multi,
                                chipConfig:
                                    const ChipConfig(wrapType: WrapType.scroll),
                                dropdownHeight: 400,
                                optionTextStyle: const TextStyle(fontSize: 16),
                                selectedOptionIcon:
                                    const Icon(Icons.check_circle),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20),
                          child: FilledButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorList[
                                    4], // Cambia el color de fondo aquí
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
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Existen campos incompletos', // Mensaje de la excepción
                                    toastLength: Toast
                                        .LENGTH_LONG, // Duración del toast (Toast.LENGTH_LONG o Toast.LENGTH_SHORT)
                                    gravity: ToastGravity
                                        .CENTER, // Posición del toast (ToastGravity.TOP, ToastGravity.CENTER, ToastGravity.BOTTOM)
                                    backgroundColor: Colors
                                        .amberAccent, // Color de fondo del toast
                                    textColor: Colors
                                        .white, // Color del texto del toast
                                  );
                                }
                              },
                              child: Text(
                                "Comenzar",
                                style: Theme.of(context).textTheme.labelSmall,
                              )),
                        ),
                      ]);
                }
              })),
    ));
  }
}
