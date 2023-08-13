import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import '../../config/helpers/param.dart';
import '../../config/theme/app_theme.dart';
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
        'exerciseId': 4,
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
    //final exerciseProv = context.watch<ExerciseProvider>();
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30, right: 5, left: 5, bottom: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
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
              child: _listPagesExercises(recorderProv),
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
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: _actionBtnNext(recorderProv),
                      ),
                    if (currentPageIndex == _pagesExercisesFounded.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: _actionBtnGoHome(recorderProv, context),
                      ),
                  ],
                )),
          ],
        ),
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
      child: const Text('FINALIZAR'),
    );
  }

  ElevatedButton _actionBtnNext(final recorderProv) {
    return ElevatedButton(
      onPressed: (!recorderProv.existAudio && !recorderProv.isExerciseFinished)
          ? null
          : () async {
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
