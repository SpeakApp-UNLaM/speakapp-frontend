import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/presentations/screens/views/phoneme_view.dart';

class ButtonHomeExercise extends StatefulWidget {
  const ButtonHomeExercise({
    super.key,
  });

  @override
  State<ButtonHomeExercise> createState() => _ButtonHomeExerciseState();
}

class _ButtonHomeExerciseState extends State<ButtonHomeExercise> {
  static const double _shadowSize = 4;
  double _position = 4;
  @override
  Widget build(BuildContext context) {
    final double _height = 150 - _shadowSize;
    final double _width = 300 - _shadowSize;
    return GestureDetector(
        onTapUp: (_) {
          setState(() {
            _position = 4;
          });
        },
        onTapDown: (_) {
          setState(() {
            _position = 0;
          });
        },
        onTapCancel: () {
          setState(() {
            _position = 4;
          });
        },
        child: Container(
          height: _height + _shadowSize,
          width: _width + _shadowSize,
          // Ancho personalizado
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: _height,
                  width: _width,
                  decoration: BoxDecoration(
                    color: colorList[0],
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 10),
                bottom: _position,
                right: _position,
                curve: Curves.easeIn,
                child: Container(
                  height: _height,
                  width: _width,
                  decoration: BoxDecoration(
                    color: colorList[0],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: FloatingActionButton(
                    heroTag: 'exercise_screen',
                    onPressed: () {
                      context.pushNamed(PhonemeView.name);
                    },
                    backgroundColor: colorList[0],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.extension,
                          size: 70,
                          color: colorList[1],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Practicas",
                            style: TextStyle(
                              fontSize: 18,
                              color: colorList[1],
                              fontFamily: 'IkkaRounded',
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
