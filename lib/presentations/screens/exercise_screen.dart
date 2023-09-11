import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
import '../../models/exercise_model.dart';
import '../../providers/recorder_provider.dart';

class ExerciseParameters {
  final int idPhoneme;
  final String namePhoneme;
  final List<Categories> categories;
  final int level;
  const ExerciseParameters(
      {required this.idPhoneme,
      required this.namePhoneme,
      required this.categories,
      required this.level});
}

class ExerciseScreen extends StatefulWidget {
  final ExerciseParameters object;
  const ExerciseScreen({super.key, required this.object});

  @override
  ExerciseScreenState createState() => ExerciseScreenState();
}

class ExerciseScreenState extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  final PageController _pc = PageController();
  Future? _fetchData;
  final List<StatefulWidget> _pagesExercisesFounded = [];
  late final AnimationController _controller;
  bool _dataLoaded = false;

  Future<Response> fetchData() async {
    Map<String, dynamic> data = {
      "phonemeId": widget.object.idPhoneme,
      "level": widget.object.level,
      "categories": widget.object.categories.map((category) {
        return category.toString().split('.').last;
      }).toList()
    };
    final response = await Api.post(Param.getExercises, data);
    for (var element in response.data) {
      _pagesExercisesFounded.add(ExerciseModel.fromJson(element)
          .fromEntity(widget.object.namePhoneme));
    }

    return null;
  }

  int currentPageIndex = 0;
  int exerciseIteration = 0;
  bool _showCongratulations = false;

  @override
  void initState() {
    super.initState();
    _fetchData = fetchData();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProv = context.watch<ExerciseProvider>();
    final recorderProv = context.watch<RecorderProvider>();
    return Scaffold(
      body: FutureBuilder(
          future: _fetchData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Stack(children: [
                Visibility(
                    visible: !_showCongratulations,
                    maintainState: true,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30, right: 5, left: 5, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => context.go('/'),
                              ),
                              Expanded(
                                  child: LinearProgressIndicator(
                                backgroundColor: colorList[7],
                                color: colorList[4],
                                value: currentPageIndex /
                                    _pagesExercisesFounded.length,
                                minHeight: 6,
                              )),
                            ],
                          ),
                          Expanded(
                            child: _listPagesExercises(exerciseProv),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  if (currentPageIndex <
                                          _pagesExercisesFounded.length - 1 //&&
                                      //(recorderProv.existAudio ||
                                      //recorderProv.isExerciseFinished)
                                      )
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: _actionBtnNext(
                                          exerciseProv, recorderProv),
                                    ),
                                  if (currentPageIndex ==
                                      _pagesExercisesFounded.length - 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: _actionBtnGoHome(
                                          exerciseProv, context),
                                    ),
                                ],
                              )),
                        ],
                      ),
                    )),
                Visibility(
                    visible: _showCongratulations,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 200),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                                '¡Sigue intentandolo, lo estas haciendo increible!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'IkkaRounded',
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                          Lottie.asset(
                            'assets/animations/congrats.json',
                            controller: _controller,
                            onLoaded: (composition) {
                              // Configure the AnimationController with the duration of the
                              // Lottie file and start the animation.
                              _controller
                                ..duration = composition.duration
                                ..forward();
                            },
                          ),
                        ],
                      ),
                    ))
              ]);
            }
          }),
    );
  }

  PageView _listPagesExercises(ExerciseProvider exerciseProv) {
    return PageView.builder(
      itemCount: _pagesExercisesFounded.length,
      controller: _pc,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (int pageIndex) {
        setState(() {
          currentPageIndex = pageIndex;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: _pagesExercisesFounded[index],
        );
      },
    );
  }

  ElevatedButton _actionBtnGoHome(
      ExerciseProvider exerciseProv, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        //TODO: DESCOMENTAR LINEA SENDTRANSCRIPTION
        //await recorderProv.sendTranscription();
        //exerciseProv.resetAudio();
        context.go('/');
      },
      child: const Text('FINALIZAR'),
    );
  }

  ElevatedButton _actionBtnNext(
      ExerciseProvider exerciseProv, RecorderProvider recorderProv) {
    return ElevatedButton(
      onPressed: (!exerciseProv.isExerciseFinished)
          ? null
          : () async {
              //TODO: DESCOMENTAR LINEA 153 PARA EJECUTAR CORRECTAMENTE PROCESO
              //await recorderProv.sendTranscription();

              recorderProv.resetAudio();
              exerciseProv.unfinishExercise();

              setState(() {
                exerciseIteration++;
              });

              // Muestra la animación de felicitación cada 3 iteraciones
              if (exerciseIteration % 3 == 0) {
                _showCongratulations = true;
                Future.delayed(const Duration(seconds: 6), () {
                  setState(() {
                    _showCongratulations = false;
                  });
                });
              } // Incrementa el contador de iteraciones de ejercicio
              // Espera 5 segundos antes de cambiar _showCongratulations a false

              _pc.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linearToEaseOut,
              );
            },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 50),
        foregroundColor: colorList[4],
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(32), // Cambia el valor del radio de borde
        ),
      ),
      child: Text(
        'CONTINUAR',
        style: TextStyle(
            fontFamily: 'IkkaRounded',
            fontSize: 14,
            color: Theme.of(context).primaryColorDark),
      ),
    );
  }
}
