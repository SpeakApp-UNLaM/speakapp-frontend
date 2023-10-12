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
import 'home_screen_specialist.dart';

class CardUser extends StatefulWidget {
  const CardUser({
    super.key,
  });

  @override
  CardUserState createState() => CardUserState();
}

class CardUserState extends State<CardUser> with TickerProviderStateMixin {
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
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 20,
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola!', style: Theme.of(context).textTheme.labelSmall),
            Text('Tomas Gonzalez',
                style: Theme.of(context).textTheme.labelMedium)
          ],
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: PopupMenuButton(
                    color: colorList[7],
                    onSelected: (sampleItem) {},
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<SampleItem>>[
                          const PopupMenuItem<SampleItem>(
                            value: SampleItem.config,
                            child: Row(
                              children: [
                                Icon(Icons.settings),
                                SizedBox(width: 8),
                                Text('Configuración'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<SampleItem>(
                            value: SampleItem.logOut,
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 8),
                                Text('Salir'),
                              ],
                            ),
                          ),
                        ],
                    child: Icon(
                      Icons.notifications,
                      color: colorList[7],
                    )),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: PopupMenuButton(
                color: colorList[7],
                onSelected: (SampleItem item) {
                  switch (item) {
                    case SampleItem.logOut:
                      context.read<LoginProvider>().onLogOut(context);
                    default:
                      return;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem>>[
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.config,
                        child: Row(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: 8),
                            Text('Configuración'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.logOut,
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 8),
                            Text('Salir'),
                          ],
                        ),
                      ),
                    ],
                child: const CircleAvatar(
                  //TODO GET IMAGE FROM USER
                  backgroundImage: AssetImage('assets/niño-feliz.jpg'),
                )),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Theme.of(context).primaryColorLight,
              height: 1.0,
            )),
      ),
      body: Container(
        width: MediaQuery.of(context)
            .size
            .width, // Ocupa todo el ancho de la pantalla
        margin: const EdgeInsets.all(30.0),
        child: Card(
          color: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 6,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(23),
                child: Center(
                  child: SearchBar(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Theme.of(context).primaryColor)),
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
                                        context.go("/",
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
      ),
    );
  }
}
