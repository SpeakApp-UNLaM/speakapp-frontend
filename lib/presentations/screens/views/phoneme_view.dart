import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/config/helpers/api.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/models/task_model.dart';
import 'package:sp_front/presentations/widgets/button_phoneme.dart';
import '../../../config/helpers/param.dart';

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
        body: SingleChildScrollView(
            child: Column(children: [
          _ListViewNM(buttonsGroupLists: buttonsGroupLists)
        ])));
  }

  Future<void> _getData() async {
    final response = await Api.get("${Param.getTasks}/1");
    for (var element in response) {
      buttonsGroupLists
          .add(TaskModel.fromJson(element).toButtonPhonemeEntity());
    }

    setState(() {});
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
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        spacing: 30,
        runSpacing: 30, // Espacio horizontal entre los elementos
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
