import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
import '../../models/patient_model.dart';
import '../../providers/auth_provider.dart';

class ChoicePatientScreen extends StatefulWidget {
  final String name = "choicePatientScreen";
  final String route;
  const ChoicePatientScreen({super.key, required this.route});

  @override
  ChoicePatientScreenState createState() => ChoicePatientScreenState();
}

class ChoicePatientScreenState extends State<ChoicePatientScreen>
    with TickerProviderStateMixin {
  final List<PatientModel> _patientsList = [];
  Future? _fetchData;

  Future fetchData() async {
    final response = await Api.get(Param.getPatients);
    if (response != null) {
      for (var element in response) {
        _patientsList.add(PatientModel.fromJson(element));
      }

      _patientsList.sort((a, b) => (a.lastName)
        .compareTo(b.lastName));
    }

    return response;
  }

  @override
  void initState() {
    _fetchData = fetchData();
    super.initState();
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
              padding: const EdgeInsets.symmetric(vertical: 23),
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
            Container(
              height: 400,
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: _fetchData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('${snapshot.error}'));
                      } else {
                        return ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade400),
                            itemCount: _patientsList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                title: Text(
                                  '${_patientsList[index].firstName} ${_patientsList[index].lastName}',
                                  style: GoogleFonts.nunito(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ),
                                leading: _patientsList[index].imageData ==
                                        null
                                    ? const CircleAvatar(
                                        child: ClipOval(
                                          child: Icon(Icons.person),
                                        ),
                                      )
                                    : CircleAvatar(
                                        //TODO GET IMAGE FROM USER
                                        backgroundImage: (_patientsList[index]
                                                .imageData as Image)
                                            .image),
                                trailing: FilledButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () {
                                      context.push("/${widget.route}",
                                          extra:
                                              _patientsList[index].idPatient);
                                    },
                                    child: Text("Iniciar")),
                              );
                            });
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
/*
 Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FilledButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorList[4],
                                    ),
                                    onPressed: () {
                                      authProvider.selectUser(
                                          _patientsList[index].idPatient);
                                      context.push("/${widget.route}",
                                          extra:
                                              _patientsList[index].idPatient);
                                    },
                                    child: Text(
                                      "Ingresar",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    )),
                              ),*/