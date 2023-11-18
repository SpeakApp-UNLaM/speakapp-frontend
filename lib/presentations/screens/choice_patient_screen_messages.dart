import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/models/contact_model.dart';

import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
import '../../models/patient_model.dart';
import '../../providers/auth_provider.dart';

class ChoicePatientScreenMessages extends StatefulWidget {
  final String name = "choicePatientScreen";
  final String route;
  const ChoicePatientScreenMessages({super.key, required this.route});

  @override
  ChoicePatientScreenMessagesState createState() =>
      ChoicePatientScreenMessagesState();
}

class ChoicePatientScreenMessagesState
    extends State<ChoicePatientScreenMessages> with TickerProviderStateMixin {
  List<ContactModel> _patientsList = [];
  List<Image?> _patientsImages = [];

  Future? _fetchData;

  Future fetchData() async {
    _patientsList = [];
    final response = await Api.get(Param.getContacts);

    for (var element in response) {
      _patientsList.add(ContactModel.fromJson(element));
    }

    _patientsList.sort((a, b) => (b.lastDateMessage ?? DateTime(0))
        .compareTo(a.lastDateMessage ?? DateTime(0)));

    for (var element in _patientsList) {
      _patientsImages.add(element.author.imageData == null
          ? null
          : Image.memory(base64.decode(element.author.imageData as String),
              fit: BoxFit.cover));
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
        margin: const EdgeInsets.all(15.0),
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
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey.shade400),
                            itemCount: _patientsList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                onTap: () {
                                  authProvider.selectUser(
                                      _patientsList[index].author.id,
                                      _patientsList[index].author.firstName,
                                      _patientsList[index].author.lastName,
                                      _patientsList[index].author.imageData);
                                  context.push("/${widget.route}",
                                      extra: _patientsList[index].author.id);
                                },
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                title: _patientsList[index].lastMessage != null
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "${_patientsList[index].author.firstName} ${_patientsList[index].author.lastName}",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.nunito(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "${_patientsList[index].lastMessage}",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.nunito(
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "${_patientsList[index].author.firstName} ${_patientsList[index].author.lastName}",
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                leading: _patientsList[index]
                                            .author
                                            .imageData ==
                                        null
                                    ? const CircleAvatar(
                                        radius: 20,
                                        child: ClipOval(
                                          child: Icon(Icons.person),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            (_patientsImages[index] as Image)
                                                .image),
                                trailing: _patientsList[index]
                                            .lastDateMessage !=
                                        null
                                    ? Text(
                                        DateFormat('dd/MM/yyyy HH:mm').format(
                                            (_patientsList[index]
                                                        .lastDateMessage
                                                    as DateTime)
                                                .subtract(
                                                    const Duration(hours: 3))),
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey.shade500,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : const Text(""),
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