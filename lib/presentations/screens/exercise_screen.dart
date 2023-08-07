import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/helpers/param.dart';
import '../../models/exercise_model_new.dart';
import '../../providers/recorder_provider.dart';

class ExerciseScreen extends StatefulWidget {
  final int idPhoneme;
  final String namePhoneme;
  final String level;
  final String categorias;

  const ExerciseScreen(
      {super.key,
      required this.idPhoneme,
      required this.namePhoneme,
      required this.level,
      required this.categorias});

  @override
  ExerciseScreenState createState() => ExerciseScreenState();
}

class ExerciseScreenState extends State<ExerciseScreen> {
  final PageController _pc = PageController();

  final List<StatefulWidget> _pagesExercisesFounded = [];
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    _getData(widget.idPhoneme, widget.level, widget.categorias);
  }

  Future<void> _getData(int idPhoneme, String nombre, String categorias) async {
    //TODO: GET EXERCISE DEL PHONEME, LEVEL, CATEGORY, USER || JSON EXAMPLE
    //final response = await Api.get(Param.getExercises);

    /** FINAL
     * 
     * REQUEST
{
   'phonemeId': 1,
   'category': ['silabas', 'palabras'],
   'level': 2
 }

{
   'phonemeId': 1,
   'category': ['palabras'],
   'level': 3
}

//RESPONSE

{
   'exerciseId': 1,
   'type': 'speak', ///enum EXERCISE_TYPE
   'result': 'ra',
   'images': [
     {
      'name': 'rata', //string
      'base64': 'assets/rat.png', //string
      'divided_name': 'ra-ta' //string
     },
   ], 
}

     */

    List<Map<String, dynamic>> exerciseDataFromDatabase = [
      {
        'exerciseId': 1,
        'type': TypeExercise.speak,

        ///enum EXERCISE_TYPE
        'result': 'ra',
        'images': [
          {
            'name': 'rata', //string
            'base64': Param.base64Rata, //string
            'divided_name': 'ra-ta' //string
          },
        ],
      },
      {
        'exerciseId': 2,
        'type': TypeExercise.listenSelection,

        ///enum EXERCISE_TYPE
        'result': 'ra',
        'images': [
          {
            'name': 'rata', //string
            'base64': Param.base64Rata, //TEMPORAL PARA TESTEAR YA CON BASE64
            'divided_name': 'ra-ta' //string
          },
          {
            'name': 'caramelo', //string
            'base64':
                Param.base64Caramelo, //TEMPORAL PARA TESTEAR YA CON BASE64
            'divided_name': 'ra-ta' //string
          },
        ],
      },
      {
        'exerciseId': 3,
        'type': TypeExercise.listenSelection,

        ///enum EXERCISE_TYPE
        'result': 'ra',
        'images': [
          {
            'name': 'rata', //string
            'base64': Param.base64Rata, //TEMPORAL PARA TESTEAR YA CON BASE64
            'divided_name': 'ra-ta' //string
          },
          {
            'name': 'caramelo', //string
            'base64':
                Param.base64Caramelo, //TEMPORAL PARA TESTEAR YA CON BASE64
            'divided_name': 'ra-ta' //string
          },
        ],
      },
    ];

    for (var element in exerciseDataFromDatabase) {
      _pagesExercisesFounded.add(
          ExerciseModelNew.fromJson(element).fromEntity(widget.namePhoneme));
    }

    //output_expected-> result_obtained
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
                    (recorderProv.existAudio ||
                        recorderProv.isExerciseFinished))
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
