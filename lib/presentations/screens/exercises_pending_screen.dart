import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sp_front/domain/entities/exercise.dart';
import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../domain/entities/pending.dart';
import '../../models/exercise_model.dart';
import '../../models/pending_model.dart';
import 'exercise_screen.dart';

class PageViewScreen extends StatefulWidget {
  final int codeGroupExercise;
  const PageViewScreen({super.key, required this.codeGroupExercise});

  @override
  PageViewScreenState createState() => PageViewScreenState();
}

class PageViewScreenState extends State<PageViewScreen> {
  final PageController _pc = PageController();

  List<ExerciseScreen> _pagesExercisesFounded = [];
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<List<Exercise>> getExercisesList() async {
    final response = await Api.get(Param.getExercises);
    List<Exercise> exercises = [];
    for (var element in response) {
      exercises.add(ExerciseModel.fromJson(element).toExerciseEntity());
    }
    return exercises;
  }

  Future<List<Pending>> getPendingList() async {
    final response = await Api.get(Param.getPending);
    List<Pending> pending = [];
    for (var element in response) {
      pending.add(PendingModel.fromJson(element).toPendingEntity());
    }
    return pending;
  }

  Future<void> _getData() async {
    Api.configureDio(Param.urlServer);
    List<Exercise> exercises = await getExercisesList();
    List<Pending> pendings = await getPendingList();
    Set<ExerciseScreen> conjuntoResultante = {};

    List<Exercise> exercisesOnlyGroup = exercises
        .where((exercise) => exercise.idGroup == widget.codeGroupExercise)
        .toList();
    for (Exercise exercise in exercisesOnlyGroup) {
      log("Datos encontrados: ${exercise.letra} ${exercise.idGroup}.");
      if (pendings.any((pending) => pending.idExercise == exercise.id)) {
        conjuntoResultante.add(ExerciseScreen(exercise: exercise));
      }
    }
    _pagesExercisesFounded = conjuntoResultante.toList();
    setState(() {
      _pagesExercisesFounded = conjuntoResultante.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _listPagesExercises(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPageIndex > 0) _actionBtnBack(),
                if (currentPageIndex < _pagesExercisesFounded.length - 1)
                  _actionBtnNext(),
                if (currentPageIndex == _pagesExercisesFounded.length - 1)
                  _actionBtnGoHome(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PageView _listPagesExercises() {
    return PageView.builder(
      itemCount: _pagesExercisesFounded.length,
      controller: _pc,
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

  ElevatedButton _actionBtnGoHome() {
    return ElevatedButton(
      onPressed: () {
        // TODO:Acción cuando el usuario está en la última página
      },
      child: const Text('Finalizar grupo de ejercicios'),
    );
  }

  ElevatedButton _actionBtnNext() {
    return ElevatedButton(
      onPressed: () {
        //TODO: LOGICA PARA REGISTRAR RECORDER Y RESULTADOS
        _pc.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.linearToEaseOut,
        );
        setState(() {
          currentPageIndex++;
        });
      },
      child: const Text('Siguiente'),
    );
  }

  ElevatedButton _actionBtnBack() {
    return ElevatedButton(
      onPressed: () {
        _pc.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        setState(() {
          currentPageIndex--;
        });
      },
      child: const Text('Atrás'),
    );
  }
}
