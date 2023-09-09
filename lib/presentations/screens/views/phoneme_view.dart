import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/presentations/widgets/button_phoneme.dart';
import '../../../config/helpers/task_handled.dart';
import '../../../domain/entities/task.dart';

class PhonemeView extends StatefulWidget {
  static const String name = 'pending';

  const PhonemeView({Key? key}) : super(key: key);

  @override
  PhonemeViewState createState() => PhonemeViewState();
}

class PhonemeViewState extends State<PhonemeView> {
  List<ButtonPhoneme> buttonsGroupLists = [];
  TaskHandled taskHandled = TaskHandled();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorList[7],
          toolbarHeight: 80,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Vamos a practicar',
                  style: TextStyle(
                      fontSize: 21,
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'IkkaRounded',
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 10),
              Text('Seleccione un fonema para practicar sus silabas:',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ))
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: FutureBuilder<List<Task>>(
          future: taskHandled.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                  child: _ListViewCustomized(tasks: snapshot.data ?? []));
            } else {
              return const Text('No se han cargado datos.');
            }
          },
        ));
  }
}

class _ListViewCustomized extends StatelessWidget {
  final List<ButtonPhoneme> buttonsGroupLists = [];

  final List<Task> tasks;

  _ListViewCustomized({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isNotEmpty) {
      for (int i = 0; i < tasks.length; i++) {
        buttonsGroupLists.add(ButtonPhoneme(
          tag: tasks[i].phoneme.idPhoneme.toString(),
          task: tasks[i],
        ));
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        spacing: 30,
        runSpacing: 30,
        children: [
          for (var i = 0; i < buttonsGroupLists.length; i += 2)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonsGroupLists[i],
                    if (i + 1 < buttonsGroupLists.length)
                      buttonsGroupLists[i + 1],
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
