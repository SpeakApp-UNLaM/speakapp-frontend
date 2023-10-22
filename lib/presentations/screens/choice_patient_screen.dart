import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
import '../../models/patient_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/login_provider.dart';
import 'home_specialist_screen.dart';

class ChoicePatientScreen extends StatefulWidget {
  final String name = "choicePatientScreen";
  const ChoicePatientScreen({
    super.key,
  });

  @override
  ChoicePatientScreenState createState() => ChoicePatientScreenState();
}

class ChoicePatientScreenState extends State<ChoicePatientScreen>
    with TickerProviderStateMixin {
  final List<PatientModel> _patientsList = [];
  Future? _fetchData;

  Future fetchData() async {
    final response = await Api.get(Param.getPatients);

    for (var element in response) {
      _patientsList.add(PatientModel.fromJson(element));
    }

    return response;
  }

  @override
  void initState() {
    super.initState();
    _fetchData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context)
            .size
            .width, // Ocupa todo el ancho de la pantalla
        margin: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(23),
              child: Center(
                child: SearchBar(
                    textStyle: MaterialStateProperty.all(
                        Theme.of(context).textTheme.titleMedium),
                    hintText: 'Buscar paciente',
                    hintStyle: MaterialStateProperty.all(
                        Theme.of(context).textTheme.titleMedium),
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 100,
                    ),
                    trailing: [
                      IconButton(
                        icon: Icon(Icons.search,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {},
                      ),
                    ],
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
            const SizedBox(height: 10.0),
            FutureBuilder(
                future: _fetchData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _patientsList.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    '${_patientsList[index].firstName} ${_patientsList[index].lastName}',
                                    style: GoogleFonts.nunito(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FilledButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorList[4],
                                    ),
                                    onPressed: () {
                                      authProvider.selectUser(
                                          _patientsList[index].idPatient);
                                      context.push("/rfi",
                                          extra:
                                              _patientsList[index].idPatient);
                                    },
                                    child: Text(
                                      "Ingresar",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    )),
                              ),
                            ],
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}
