import 'package:flutter/material.dart';
import 'package:sp_front/config/helpers/api.dart';
import 'package:sp_front/domain/entities/pending.dart';
import 'package:sp_front/presentations/widgets/button_phoneme.dart';
import '../../../config/helpers/param.dart';
import '../../../domain/entities/phoneme.dart';
import '../../../models/phoneme_model.dart';
import '../../../models/pending_model.dart';

class PhonemeView extends StatefulWidget {
  static const String name = 'pending';

  const PhonemeView({Key? key}) : super(key: key);

  @override
  PhonemeViewState createState() => PhonemeViewState();
}

class PhonemeViewState extends State<PhonemeView> {
  List<ButtonPhoneme> buttonsGroupLists = [];

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

  void _getData() {
    //TODO: GET PHONEMES DESDE TASK_GROUP
    buttonsGroupLists.add(const ButtonPhoneme(name: "RR", codeGroup: 1));
    buttonsGroupLists.add(const ButtonPhoneme(name: "L", codeGroup: 2));

    /*
    List<GroupExercise> groups = await getGroupExercisesList();
    List<Pending> pendings = await getPendingList();
    Set<ButtonPhoneme> conjuntoResultante = {};
    for (GroupExercise group in groups) {
      if (pendings.any((pending) => pending.idGroupExercise == group.id)) {
        conjuntoResultante.add(
            ButtonPhoneme(name: group.wordGroupExercise, codeGroup: group.id));
      }
    }
    buttonsGroupLists = conjuntoResultante.toList();
    setState(() {});

    */
    setState(() {});
  }

  Future<List<Phoneme>> getGroupExercisesList() async {
    final response = await Api.get(Param.getGroupExercises);
    List<Phoneme> groupExercises = [];
    for (var element in response) {
      groupExercises
          .add(PhonemeModel.fromJson(element).toGroupExerciseEntity());
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

  final List<ButtonPhoneme> buttonsGroupLists;

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
