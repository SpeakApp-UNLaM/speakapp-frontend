import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/presentations/widgets/button_phoneme.dart';
import 'package:sp_front/presentations/widgets/lottie_animation.dart';
import '../../../config/helpers/task_handled.dart';
import '../../../domain/entities/task.dart';

class PhonemeView extends StatefulWidget {
  static const String name = 'pending';
  final int idPatient;
  const PhonemeView({Key? key, required this.idPatient}) : super(key: key);

  @override
  PhonemeViewState createState() => PhonemeViewState();
}

class PhonemeViewState extends State<PhonemeView>
    with TickerProviderStateMixin {
  List<ButtonPhoneme> buttonsGroupLists = [];
  TaskHandled taskHandled = TaskHandled();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10),
              Text('Seleccione un fonema para practicar sus sílabas:',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: FutureBuilder<List<Task>>(
          future: taskHandled.fetchData(idPatient: widget.idPatient),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset(
                      'assets/animations/Loading.json',
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..repeat();
                      },
                    )),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data?.length != 0) {
              return SingleChildScrollView(
                  child: _ListViewCustomized(tasks: snapshot.data ?? []));
            } else if (snapshot.data?.length == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Center(
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset(
                        'assets/animations/NoResults.json',
                        controller: _controller,
                        onLoaded: (composition) {
                          // Configure the AnimationController with the duration of the
                          // Lottie file and start the animation.
                          _controller
                            ..duration = composition.duration
                            ..repeat();
                        },
                      )),
                ),
                Text(
                  "Aún no posee ejercicios asignados",
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorDark),
                )
              ]);
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimationL(
                      animationPath: 'assets/animations/BoyJumping.json',
                      size: 500),
                  Text(
                    'En hora buena!\nNo tienes actividades pendientes!',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
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
