import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/domain/entities/exercise.dart';
import '../../config/helpers/api.dart';
import '../../config/helpers/param.dart';
import '../../domain/entities/pending.dart';
import '../../models/exercise_model.dart';
import '../../models/pending_model.dart';
import '../../providers/recorder_provider.dart';
import 'page_exercise_screen.dart';

class ExerciseScreen extends StatefulWidget {
  final int codeGroupExercise;
  const ExerciseScreen({super.key, required this.codeGroupExercise});

  @override
  ExerciseScreenState createState() => ExerciseScreenState();
}

class ExerciseScreenState extends State<ExerciseScreen> {
  final PageController _pc = PageController();

  List<PageExerciseScreen> _pagesExercisesFounded = [];
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
    /*
    List<Exercise> exercises = await getExercisesList();
    List<Pending> pendings = await getPendingList();
    Set<PageExerciseScreen> conjuntoResultante = {};

    List<Exercise> exercisesOnlyGroup = exercises
        .where((exercise) => exercise.idGroup == widget.codeGroupExercise)
        .toList();
    for (Exercise exercise in exercisesOnlyGroup) {
      if (pendings.any((pending) => pending.idExercise == exercise.id)) {
        conjuntoResultante.add(PageExerciseScreen(exercise: exercise));
      }
    }
    _pagesExercisesFounded = conjuntoResultante.toList();
  */
    //TODO: GET EXERCISE DEL PHONEME, LEVEL, CATEGORY, USER
    if (widget.codeGroupExercise == 1) {
      _pagesExercisesFounded.add(PageExerciseScreen(
          exercise: Exercise(
              id: 1, pathImg: "assets/caramelo.png", letra: "R", idGroup: 1)));
      _pagesExercisesFounded.add(PageExerciseScreen(
          exercise: Exercise(
              id: 2, pathImg: "assets/rat.png", letra: "R", idGroup: 1)));
    } else {
      _pagesExercisesFounded.add(PageExerciseScreen(
          exercise: Exercise(
              id: 3, pathImg: "assets/clavo2.png", letra: "L", idGroup: 2)));
      _pagesExercisesFounded.add(PageExerciseScreen(
          exercise: Exercise(
              id: 4, pathImg: "assets/flan.png", letra: "L", idGroup: 2)));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final recorderProv = context.watch<RecorderProvider>();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _listPagesExercises(recorderProv),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPageIndex < _pagesExercisesFounded.length - 1 &&
                    recorderProv.existAudio)
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _actionBtnNext(recorderProv),
                    ),
                  ),
                if (currentPageIndex == _pagesExercisesFounded.length - 1)
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _actionBtnGoHome(recorderProv, context),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PageView _listPagesExercises(final recorderProv) {
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

  ElevatedButton _actionBtnGoHome(final recorderProv, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        //TODO: DESCOMENTAR LINEA SENDTRANSCRIPTION
        //await recorderProv.sendTranscription();
        recorderProv.resetAudio();
        Navigator.pop(context, 'fin_grupo');
      },
      child: const Text('Finalizar'),
    );
  }

  ElevatedButton _actionBtnNext(final recorderProv) {
    return ElevatedButton(
      onPressed: () async {
        //TODO: DESCOMENTAR LINEA 153 PARA EJECUTAR CORRECTAMENTE PROCESO
        //await recorderProv.sendTranscription();
        recorderProv.resetAudio();
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
}
