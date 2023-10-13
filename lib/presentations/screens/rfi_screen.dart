import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/domain/entities/result_exercise.dart';
import 'package:swipable_stack/src/model/swipe_properties.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
import '../../domain/entities/rfi.dart';
import '../../models/rfi_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/exercise_provider.dart';

class RfiScreen extends StatefulWidget {
  const RfiScreen({super.key});

  @override
  RfiScreenState createState() => RfiScreenState();
}

class RfiScreenState extends State<RfiScreen> with TickerProviderStateMixin {
  late final SwipableStackController _controllerSwipable;
  late final AnimationController _controller;
  Future? _fetchData;
  final List<RFI> _rfiImages = [];
  final List<RFIExerciseModel> _rfiResults = [];
  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    _fetchData = _fechData();
    _controller = AnimationController(vsync: this);
    _controllerSwipable = SwipableStackController()
      ..addListener(_listenController);
  }

  Future _fechData() async {
    final response = await Api.get(Param.getRfi);
    if (response is! String && response != null) {
      for (var element in response) {
        _rfiImages.add(RFIExerciseModel.fromJson(element).toRFIEntity());
      }
    }
    return response;
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerSwipable
      ..removeListener(_listenController)
      ..dispose();
    super.dispose();
  }

  int indexCards = 0;
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final exerciseProv = context.watch<ExerciseProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RFI',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
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
          } else if (_rfiImages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No se encontraron ejercicios!",
                      style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(
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
                            extra: authProvider.prefs.getInt('userId') as int);
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
            return SafeArea(
              top: false,
              child: Stack(
                children: [
                  Visibility(
                    visible: !exerciseProv.isExerciseFinished,
                    child: LinearProgressIndicator(
                      backgroundColor: colorList[7],
                      color: colorList[4],
                      value: indexCards / _rfiImages.length,
                      minHeight: 6,
                    ),
                  ),
                  SwipableStack(
                    onSwipeCompleted: (index, direction) {
                      if (direction == SwipeDirection.left) {
                        _rfiResults.add(RFIExerciseModel(
                            idRfi: _rfiImages[index].idRfi,
                            imageData: _rfiImages[index].imageData,
                            name: _rfiImages[index].name,
                            status: "NO"));
                      } else {
                        _rfiResults.add(RFIExerciseModel(
                            idRfi: _rfiImages[index].idRfi,
                            imageData: _rfiImages[index].imageData,
                            name: _rfiImages[index].name,
                            status: "YES"));
                      }
                      setState(() {
                        indexCards++;
                      });
                      if (indexCards >= _rfiImages.length) {
                        exerciseProv.saveParcialResult(ResultExercise(
                            type: TypeExercise.consonantal_syllable,
                            audio: "audio",
                            pairImagesResult: [],
                            idTaskItem: 1));
                      }
                    },
                    controller: _controllerSwipable,
                    onWillMoveNext: (index, swipeDirection) {
                      final allowed = [
                        SwipeDirection.left,
                        SwipeDirection.right
                      ];
                      return allowed.contains(swipeDirection);
                    },
                    overlayBuilder: (context, swipeProperty) =>
                        overlayBuilderCard(swipeProperty),
                    itemCount: _rfiImages.length,
                    builder: (context, properties) {
                      return Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: MediaQuery.of(context).size.height - 350,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ), // Establecer la altura deseada
                              child: Card(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          -50,
                                      child: Image.memory(
                                        base64.decode(
                                            _rfiImages[properties.index]
                                                .imageData),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      _rfiImages[properties.index]
                                          .name
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  ],
                                ),
                              )));
                    },
                  ),
                  Visibility(
                    visible: !exerciseProv.isExerciseFinished,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Deslizar hacia la derecha si lo pronunció correcto\nDeslizar hacia la izquierda si lo pronunció incorrecto",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              rewindButton(),
                              resetButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: exerciseProv.isExerciseFinished,
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 70),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('FELICITACIONES',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                      onPressed: () async {
                                        int idPatient = authProvider.prefs
                                            .getInt('userId') as int;
                                        exerciseProv.sendRFIResults(
                                            _rfiResults, idPatient);
                                        context.go('/', extra: idPatient);
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
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget overlayBuilderCard(OverlaySwipeProperties swipeProperty) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height - 350,
        child: Opacity(
            opacity: min(swipeProperty.swipeProgress, .8),
            child: Card(
              elevation: 10,
              child: swipeProperty.direction == SwipeDirection.right
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 60.0,
                    )
                  : const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 60.0,
                    ),
            )),
      ),
    );
  }

  Align rewindButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: FloatingActionButton(
        heroTag: 'rewind_rfi',
        onPressed: () {
          setState(() {
            indexCards--;
            if (indexCards < 0) {
              indexCards = 0;
            } else {
              _rfiResults.removeLast();
              _controllerSwipable.rewind();
            }
          });
        },
        child: const Icon(
          Icons.fast_rewind_outlined,
        ),
      ),
    );
  }

  Align resetButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        heroTag: 'reset_rfi',
        onPressed: () {
          _controllerSwipable.currentIndex = 0;
          setState(() {
            _rfiResults.clear();
            indexCards = 0;
          });
        },
        child: const Icon(
          Icons.restore,
        ),
      ),
    );
  }
}