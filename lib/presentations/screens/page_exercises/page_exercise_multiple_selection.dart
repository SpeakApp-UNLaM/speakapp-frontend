import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/domain/entities/result_pair_images.dart';
import 'package:sp_front/providers/exercise_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/helpers/param.dart';
import '../../../config/theme/app_theme.dart';
import '../../../domain/entities/result_exercise.dart';
import '../../../models/image_model.dart';
import '../../../providers/tts_provider.dart';

class PageExerciseMultipleSelection extends StatefulWidget {
  final int idTaskItem;
  final List<ImageExerciseModel> images;
  final String namePhoneme;
  final String syllable;

  const PageExerciseMultipleSelection(
      {Key? key,
      required this.images,
      required this.namePhoneme,
      required this.idTaskItem,
      required this.syllable})
      : super(key: key);

  @override
  PageExerciseMultipleSelectionState createState() =>
      PageExerciseMultipleSelectionState();
}

class PageExerciseMultipleSelectionState
    extends State<PageExerciseMultipleSelection> {
  List<String> imagesSelected = [];
  List<ResultPairImages> pairImages = [];
  late List<Image> _listImages;
  bool speakSlow = true;

  @override
  void initState() {
    super.initState();
    widget.images.shuffle();
    _listImages = widget.images.map((img) {
      return Image.memory(
        base64.decode(img.imageData),
        fit: BoxFit.cover,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const colors = <Color>[
      Colors.blue,
      Colors.brown,
      Colors.red,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.blueGrey,
      Colors.lime
    ];
    final exerciseProv = context.watch<ExerciseProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Text('¡Vamos a practicar!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 15.0),
                Text('¿Cuál o cuáles imágenes contienen el siguiente sonido?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    //exerciseProv.finishExercise();
                    setState(() {
                      speakSlow = !speakSlow;
                    });
                    TtsProvider()
                        .speak(widget.syllable, speakSlow == true ? 0.1 : 0.5);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black
                                .withOpacity(0.1), // Color de la sombra
                            blurRadius: 5, // Radio de desenfoque
                            offset: Offset(0, 5))
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: 100, // Ancho mínimo deseado
                        maxWidth: MediaQuery.of(context).size.width *
                            0.35, // Ancho máximo del 30% del ancho disponible
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.volume_up_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text("Reproducir",
                                style: GoogleFonts.nunito(
                                    fontSize: 14, color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                for (var image in widget.images)
                  GestureDetector(
                    onTap: () {
                      final isSelected =
                          imagesSelected.contains(image.imageData);
                      if (isSelected) {
                        int index = imagesSelected.indexOf(image.imageData);
                        imagesSelected.remove(image.imageData);
                        pairImages.removeAt(index);
                      } else {
                        TtsProvider().speak(image.name, 0.5);
                        imagesSelected.add(image.imageData);
                        pairImages.add(ResultPairImages(
                            idImage: image.idImage, nameImage: image.name));
                      }

                      if (imagesSelected.isEmpty) {
                        exerciseProv.unfinishExercise();
                      } else {
                        exerciseProv.saveParcialResult(ResultExercise(
                            idTaskItem: widget.idTaskItem,
                            type: TypeExercise.multiple_selection,
                            audio: "",
                            pairImagesResult: pairImages));
                      }

                      //exerciseProv.finishExercise();

                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        Container(
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
                                color: imagesSelected.contains(image.imageData)
                                    ? colors[
                                        imagesSelected.indexOf(image.imageData)]
                                    : Colors.grey.shade300,
                                width: 3.0,
                              ),
                            ),
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child:
                                    _listImages[widget.images.indexOf(image)])),
                        Positioned(
                          bottom: 7,
                          right: 7,
                          child: Icon(
                            Icons.volume_up,
                            color: colorList[4],
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
