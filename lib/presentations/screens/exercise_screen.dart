import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
import '../../models/exercise_model.dart';
import '../../providers/recorder_provider.dart';

class ExerciseParameters {
  final int idPhoneme;
  final int level;
  final String namePhoneme;
  final List<Categories>? categories;

  const ExerciseParameters(
      {required this.idPhoneme,
      required this.namePhoneme,
      required this.level,
      required this.categories});
}

class ExerciseScreen extends StatefulWidget {
  final ExerciseParameters object;
  const ExerciseScreen({super.key, required this.object});

  @override
  ExerciseScreenState createState() => ExerciseScreenState();
}

class ExerciseScreenState extends State<ExerciseScreen> {
  final PageController _pc = PageController();
  Future<Response>? _fetchData;
  final List<StatefulWidget> _pagesExercisesFounded = [];

  Future<Response> fetchData() async {
    Map<String, dynamic> data = {
      "phonemeId": widget.object.idPhoneme,
      "level": widget.object.level,
      "categories": widget.object.categories
          ?.map((e) => e.toString().split('.').last)
          .toList(),
    };
    final response = await Api.post(Param.getExercises, data);
    for (var element in response.data) {
      _pagesExercisesFounded.add(ExerciseModel.fromJson(element)
          .fromEntity(widget.object.namePhoneme));
    }
    return response;
  }

  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    _fetchData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProv = context.watch<ExerciseProvider>();
    final recorderProv = context.watch<RecorderProvider>();
    return Scaffold(
      body: FutureBuilder<Response>(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
              padding:
                  const EdgeInsets.only(top: 30, right: 5, left: 5, bottom: 20),
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
                        value: currentPageIndex / _pagesExercisesFounded.length,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: _actionBtnNext(exerciseProv, recorderProv),
                            ),
                          if (currentPageIndex ==
                              _pagesExercisesFounded.length - 1)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: _actionBtnGoHome(exerciseProv, context),
                            ),
                        ],
                      )),
                ],
              ),
            );
          }
        },
      ),
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
              _pc.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linearToEaseOut,
              );
              setState(() {
                currentPageIndex++;
              });
            },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 50),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10), // Cambia el valor del radio de borde
        ),
      ),
      child: const Text('CONTINUAR'),
    );
  }
}
