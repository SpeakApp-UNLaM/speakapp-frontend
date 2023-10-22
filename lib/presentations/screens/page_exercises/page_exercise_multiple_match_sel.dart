import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../domain/entities/result_exercise.dart';
import '../../../domain/entities/result_pair_images.dart';
import '../../../models/image_model.dart';
import '../../../providers/tts_provider.dart';

const colorListPairImages = <Color>[
  Colors.blue,
  Colors.brown,
  Colors.red,
  Colors.purple,
  Colors.green,
  Colors.orange,
  Colors.blueGrey,
  Colors.lime
];

class PageExerciseMultipleMatchSel extends StatefulWidget {
  final int idTaskItem;
  final List<ImageExerciseModel> images;
  final String namePhoneme;

  const PageExerciseMultipleMatchSel(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idTaskItem})
      : super(key: key);

  @override
  PageExerciseMultipleMatchSelState createState() =>
      PageExerciseMultipleMatchSelState();
}

class PageExerciseMultipleMatchSelState
    extends State<PageExerciseMultipleMatchSel> {
  late List<Image> _listImages;
  late List<ImageExerciseModel> _shuffleListImages;

  @override
  void initState() {
    super.initState();

    _listImages = widget.images.map((img) {
      return Image.memory(
        base64.decode(img.imageData),
        fit: BoxFit.cover,
      );
    }).toList();

    _shuffleListImages = widget.images;
    //_shuffleListImages.shuffle();
  }

  List<String> audiosSelected = [], imagesSelected = [];
  List<ResultPairImages> pairImages = [];
  @override
  Widget build(BuildContext context) {
    final exerciseProv = context.watch<ExerciseProvider>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¡Vamos a practicar!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark)),
                const SizedBox(height: 20.0),
                Text('¿Qué imágen se corresponde a cada audio?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).primaryColorDark)),
                const SizedBox(height: 30.0),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 11,
                  children: _shuffleListImages.map((img) {
                    final isSelected = audiosSelected.contains(img.name);
                    final borderColor = isSelected
                        ? colorListPairImages[audiosSelected.indexOf(img.name)]
                        : Colors.grey.shade300;

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          final index = audiosSelected.indexOf(img.name);
                          if (imagesSelected.length >= audiosSelected.length) {
                            imagesSelected.removeAt(index);
                          }

                          pairImages.removeAt(index);
                          audiosSelected.remove(img.name);
                        } else {
                          TtsProvider().speak(img.name, 0.5);
                          audiosSelected.add(img.name);
                          int auxIndex = audiosSelected.lastIndexOf(img.name);
                          if (pairImages.isNotEmpty &&
                              auxIndex < pairImages.length) {
                            pairImages[auxIndex].setAudio(img.name);
                          } else {
                            pairImages.add(ResultPairImages(
                                idImage: 0, nameImage: img.name));
                          }
                        }
                        if (imagesSelected.length == widget.images.length &&
                            audiosSelected.length == widget.images.length) {
                          exerciseProv.saveParcialResult(ResultExercise(
                              idTaskItem: widget.idTaskItem,
                              type: TypeExercise.multiple_match_selection,
                              audio: "",
                              pairImagesResult: pairImages));
                        } else {
                          exerciseProv.unfinishExercise();
                        }

                        //exerciseProv.finishExercise();
                        setState(() {});
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                          border: Border.all(
                            color: borderColor,
                            width: 3.0,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Wrap(
                              children: [
                                Icon(
                                  Icons.volume_up_outlined,
                                  color: Colors.grey.shade400,
                                ),
                                Text("Reproducir",
                                    style:
                                        Theme.of(context).textTheme.titleSmall)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40.0),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: widget.images.map((img) {
                    final isSelected = imagesSelected.contains(img.imageData);
                    final borderColor = isSelected
                        ? colorListPairImages[
                            imagesSelected.indexOf(img.imageData)]
                        : Colors.grey.shade300;

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          final index = imagesSelected.indexOf(img.imageData);
                          if (audiosSelected.length >= imagesSelected.length) {
                            audiosSelected.removeAt(index);
                          }
                          pairImages.removeAt(index);
                          imagesSelected.remove(img.imageData);
                        } else {
                          imagesSelected.add(img.imageData);
                          int auxIndex =
                              imagesSelected.lastIndexOf(img.imageData);
                          if (pairImages.isNotEmpty &&
                              auxIndex < pairImages.length) {
                            pairImages[auxIndex].setIdImage(img.idImage);
                          } else {
                            pairImages.add(ResultPairImages(
                                idImage: img.idImage, nameImage: ""));
                          }
                        }
                        //exerciseProv.finishExercise();
                        if (imagesSelected.length == widget.images.length &&
                            audiosSelected.length == widget.images.length) {
                          exerciseProv.saveParcialResult(ResultExercise(
                              idTaskItem: widget.idTaskItem,
                              type: TypeExercise.multiple_match_selection,
                              audio: "",
                              pairImagesResult: pairImages));
                        } else {
                          exerciseProv.unfinishExercise();
                        }
                        setState(() {});
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Color de la sombra
                                  blurRadius: 5, // Radio de desenfoque
                                  offset: Offset(0, 4))
                            ],
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            border: Border.all(
                              color: borderColor,
                              width: 3.0,
                            ),
                          ),
                          width: 150,
                          height: 150,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: _listImages[widget.images.indexOf(img)])),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
