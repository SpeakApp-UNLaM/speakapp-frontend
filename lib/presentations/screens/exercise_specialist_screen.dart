import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/providers/auth_provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
import '../../models/exercise_model.dart';
import '../../providers/recorder_provider.dart';

// ignore: must_be_immutable
class ExerciseSpecialistScreen extends StatefulWidget {
  Map<String, dynamic> queryParameters;
  ExerciseSpecialistScreen(
      {super.key, required this.queryParameters, required this.namePhoneme});
  String namePhoneme;
  @override
  ExerciseSpecialistScreenState createState() =>
      ExerciseSpecialistScreenState();
}

class ExerciseSpecialistScreenState extends State<ExerciseSpecialistScreen>
    with TickerProviderStateMixin {
  final PageController _pc = PageController();
  Future? _fetchData;
  final List<StatefulWidget> _pagesExercisesFounded = [];
  late final AnimationController _controller;

  Future fetchData() async {
    final param = {...widget.queryParameters};
    param.remove("namePhoneme");
    final response =
        await Api.get(Param.getExercisesCustom, queryParameters: param);
    await Future.delayed(const Duration(seconds: 3), () {
      if (response != null) {
        for (var element in response) {
          _pagesExercisesFounded.add(
              ExerciseModel.fromJson(element).fromEntity(widget.namePhoneme));
        }
      }
    });
    return response;
  }

  int currentPageIndex = 0;
  int exerciseIteration = 0;
  bool _showCongratulations = false;
  bool _isFinishedExercise = false;

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
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: FutureBuilder(
          future: _fetchData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Lottie.asset(
                  'assets/animations/HelloLoading.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    _controller
                      ..duration = composition.duration
                      ..repeat();
                  },
                ),
              ));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (_pagesExercisesFounded.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No se encontraron ejercicios!",
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 44,
                      width: 244,
                      decoration: BoxDecoration(
                        color: colorList[0],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          context.go('/',
                              extra:
                                  authProvider.prefs.getInt('userId') as int);
                        },
                        backgroundColor: colorList[0],
                        elevation: 10.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("VOLVER",
                                style: Theme.of(context).textTheme.displaySmall)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Stack(children: [
                Visibility(
                    visible: !_showCongratulations && !_isFinishedExercise,
                    maintainState: true,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30, right: 5, left: 5, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  exerciseProv.unfinishExercise();
                                  Navigator.pop(context);
                                },
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width -
                                            150),
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOutSine,
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: currentPageIndex /
                                        _pagesExercisesFounded.length,
                                  ),
                                  builder: (context, value, _) =>
                                      LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(15),
                                    backgroundColor: colorList[7],
                                    color: colorList[4],
                                    value: value,
                                    minHeight: 10,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "$currentPageIndex/${_pagesExercisesFounded.length}"),
                              )
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
                                          exerciseProv, recorderProv, context),
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
                                '¡Sigue intentandolo, lo estás haciendo increíble!',
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                          ),
                          Lottie.asset(
                            'assets/animations/BoyJumping.json',
                            controller: _controller,
                            onLoaded: (composition) {
                              // Configure the AnimationController with the duration of the
                              // Lottie file and start the animation.
                              _controller
                                ..duration = composition.duration
                                ..repeat();
                            },
                          ),
                        ],
                      ),
                    )),
                Visibility(
                    visible: _isFinishedExercise,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('FELICITACIONES',
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('¡Buen trabajo, lo has conseguido!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 21,
                                  color: colorList[1],
                                )),
                          ),
                          const SizedBox(height: 50),
                          Container(
                              width: 600,
                              height: 450,
                              child: Lottie.asset(
                                'assets/animations/Confetti.json',
                                controller: _controller,
                                onLoaded: (composition) {
                                  // Configure the AnimationController with the duration of the
                                  // Lottie file and start the animation.
                                  _controller
                                    ..duration = composition.duration
                                    ..repeat();
                                },
                              )),
                          const SizedBox(height: 50),
                          SizedBox(
                            height: 50.0,
                            width: 250.0,
                            // Ancho personalizado
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: 46,
                                    width: 246,
                                    decoration: BoxDecoration(
                                      color: colorList[1],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 44,
                                  width: 244,
                                  decoration: BoxDecoration(
                                    color: colorList[0],
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      exerciseProv.finishExercise();
                                      recorderProv.resetPathAudio();
                                      recorderProv.resetProvider();
                                      exerciseProv.sendResultsExercises();

                                      if (widget.queryParameters == null) {
                                        context.go('/',
                                            extra: authProvider.prefs
                                                .getInt('userId') as int);
                                      } else {
                                        //VIENE DE TEST_EXERCISES
                                        Navigator.pop(context);
                                      }
                                    },
                                    backgroundColor: colorList[0],
                                    elevation: 10.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("FINALIZAR EJERCICIO",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  SizedBox _actionBtnGoHome(ExerciseProvider exerciseProv,
      RecorderProvider recorderProv, BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: 250.0,
      // Ancho personalizado
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: 46,
              width: 246,
              decoration: BoxDecoration(
                color: !exerciseProv.isExerciseFinished
                    ? Colors.grey.shade300
                    : colorList[1],
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
          Container(
            height: 44,
            width: 244,
            decoration: BoxDecoration(
              color: !exerciseProv.isExerciseFinished
                  ? Colors.grey.shade200
                  : colorList[0],
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: FloatingActionButton(
              heroTag: "finalizarEjercicio",
              onPressed: (!exerciseProv.isExerciseFinished)
                  ? null
                  : () async {
                      //TODO: DESCOMENTAR LINEA 153 PARA EJECUTAR CORRECTAMENTE PROCESO
                      //await recorderProv.sendTranscription();
                      //TODO: DESCOMENTAR LINEA SENDTRANSCRIPTION
                      //await recorderProv.sendTranscription();
                      //exerciseProv.resetAudio();
                      recorderProv.resetProvider();
                      setState(() {
                        _isFinishedExercise = true;
                      });
                    },
              backgroundColor: !exerciseProv.isExerciseFinished
                  ? Colors.grey.shade200
                  : colorList[0],
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CONTINUAR",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: !exerciseProv.isExerciseFinished
                          ? Colors.grey.shade300
                          : colorList[2],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtnNext(
      ExerciseProvider exerciseProv, RecorderProvider recorderProv) {
    return SizedBox(
      height: 50.0,
      width: 250.0,
      // Ancho personalizado
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: 46,
              width: 246,
              decoration: BoxDecoration(
                color: !exerciseProv.isExerciseFinished
                    ? Colors.grey.shade300
                    : colorList[1],
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
          Container(
            height: 44,
            width: 244,
            decoration: BoxDecoration(
              color: !exerciseProv.isExerciseFinished
                  ? Colors.grey.shade200
                  : colorList[0],
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: FloatingActionButton(
              onPressed: (!exerciseProv.isExerciseFinished)
                  ? null
                  : () async {
                      //TODO: DESCOMENTAR LINEA 153 PARA EJECUTAR CORRECTAMENTE PROCESO
                      //await recorderProv.sendTranscription();
                      exerciseProv.finishExercise();
                      //exerciseProv.unfinishExercise();
                      recorderProv.resetPathAudio();
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
              backgroundColor: !exerciseProv.isExerciseFinished
                  ? Colors.grey.shade200
                  : colorList[0],
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CONTINUAR",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: !exerciseProv.isExerciseFinished
                          ? Colors.grey.shade300
                          : colorList[2],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
