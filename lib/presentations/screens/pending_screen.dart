import 'package:flutter/material.dart';
import 'package:sp_front/config/helpers/api.dart';
import 'package:sp_front/domain/entities/pending.dart';
import 'package:sp_front/presentations/widgets/button_exercise_group.dart';
import '../../config/helpers/param.dart';
import '../../domain/entities/group_exercise.dart';
import '../../models/group_exercise_model.dart';
import '../../models/pending_model.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  PendingScreenState createState() => PendingScreenState();
}

class PendingScreenState extends State<PendingScreen> {
  List<ButtonExerciseGroup> buttonsGroupLists = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios'),
      ),
      body: _ListViewNM(buttonsGroupLists: buttonsGroupLists),
    );
  }

  Future<void> _getData() async {
    List<GroupExercise> groups = await getGroupExercisesList();
    List<Pending> pendings = await getPendingList();
    Set<ButtonExerciseGroup> conjuntoResultante = {};
    for (GroupExercise group in groups) {
      if (pendings.any((pending) => pending.idGroupExercise == group.id)) {
        conjuntoResultante.add(ButtonExerciseGroup(
            name: group.wordGroupExercise, codeGroup: group.id));
      }
    }
    buttonsGroupLists = conjuntoResultante.toList();
    setState(() {});
  }

  Future<List<GroupExercise>> getGroupExercisesList() async {
    final response = await Api.get(Param.getGroupExercises);
    List<GroupExercise> groupExercises = [];
    for (var element in response) {
      groupExercises
          .add(GroupExerciseModel.fromJson(element).toGroupExerciseEntity());
    }
    return groupExercises;
  }

  Future<List<Pending>> getPendingList() async {
    final response = await Api.get(Param.getPending);
    List<Pending> pending = [];
    for (var element in response) {
      pending.add(PendingModel.fromJson(element).toPendingEntity());
    }
    return pending;
  }
}

class _ListViewNM extends StatelessWidget {
  const _ListViewNM({
    required this.buttonsGroupLists,
  });

  final List<ButtonExerciseGroup> buttonsGroupLists;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.all(10.0), // Ajusta el valor según tus necesidades
      child: GridView.builder(
        itemCount: buttonsGroupLists.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return buttonsGroupLists[index];
        },
      ),
    );
  }
}
