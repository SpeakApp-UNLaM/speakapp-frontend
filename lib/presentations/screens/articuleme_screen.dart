import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/config/helpers/api.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/models/articuleme_model.dart';
import 'package:sp_front/presentations/widgets/button_play_audio.dart';
import 'package:sp_front/presentations/widgets/button_recorder.dart';
import 'package:sp_front/providers/auth_provider.dart';
import 'package:sp_front/providers/tts_provider.dart';

import '../../../config/helpers/param.dart';
import '../../../models/image_model.dart';

class ArticulemeParameters {
  final int idPhoneme;
  final String namePhoneme;

  const ArticulemeParameters({
    required this.idPhoneme,
    required this.namePhoneme,
  });
}

class ArticulemeScreen extends StatefulWidget {
  final ArticulemeParameters param;

  const ArticulemeScreen({required this.param, Key? key}) : super(key: key);

  @override
  ArticulemeScreenState createState() => ArticulemeScreenState();
}

class ArticulemeScreenState extends State<ArticulemeScreen>
    with TickerProviderStateMixin {
  Future? _fetchData;
  late ArticulemeModel _articuleme;
  late final AnimationController _controller;

  Future fetchData() async {
    final response =
        await Api.get("${Param.getArticulemes}/${widget.param.idPhoneme}");
    if (response is! String && response != null) {
      _articuleme = ArticulemeModel.fromJson(response);
    }
    setState(() {});
    if (response == null) return Response(requestOptions: RequestOptions());
    return response;
  }

  @override
  void initState() {
    super.initState();
    _fetchData = fetchData();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
        body: FutureBuilder(
            future: _fetchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Lottie.asset(
                  'assets/animations/HelloLoading.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    _controller
                      ..duration = composition.duration
                      ..repeat();
                  },
                ));
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${snapshot.error}',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 44,
                        width: 244,
                        decoration: BoxDecoration(
                          color: colorList[0],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: FloatingActionButton(
                          onPressed: () {
                            context.go('/',
                                extra:
                                    authProvider.prefs.getInt('userId') as int);
                          },
                          backgroundColor: colorList[0],
                          elevation: 10.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("VOLVER",
                                  style:
                                      Theme.of(context).textTheme.displaySmall)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No se encontraron ejercicios!",
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 44,
                        width: 244,
                        decoration: BoxDecoration(
                          color: colorList[0],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: FloatingActionButton(
                          onPressed: () {
                            context.go('/',
                                extra:
                                    authProvider.prefs.getInt('userId') as int);
                          },
                          backgroundColor: colorList[0],
                          elevation: 10.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("VOLVER",
                                  style:
                                      Theme.of(context).textTheme.displaySmall)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            verticalDirection: VerticalDirection.down,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('¡Vamos a practicar!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).primaryColorDark)),
                              SizedBox(height: 10),
                              Text('Articulema del fónema:',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color:
                                          Theme.of(context).primaryColorDark)),
                              const SizedBox(height: 50.0),
                              Text(widget.param.namePhoneme,
                                  style: TextStyle(
                                      fontFamily: 'IkkaRounded',
                                      fontSize: 50,
                                      color: colorList[1])),
                            ],
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                            ), // Establecer la altura deseada
                            child: SizedBox(
                                width: 300,
                                height: 300,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        16), // Redondear las esquinas
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.5), // Color de la sombra
                                        spreadRadius:
                                            5, // Radio de expansión de la sombra
                                        blurRadius:
                                            7, // Radio de desenfoque de la sombra
                                        offset: Offset(3,
                                            0), // Desplazamiento cero para que la sombra rodee el contenido
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.memory(
                                      base64.decode(_articuleme.imageData),
                                      fit: BoxFit.cover,
                                      width: 300,
                                      height: 300,
                                    ),
                                  ),
                                )),
                          ),
                          Spacer(),
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                height: 55.0,
                                width: 250.0,

                                // Ancho personalizado
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        height: 51,
                                        width: 246,
                                        decoration: BoxDecoration(
                                          color: colorList[1],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 49,
                                      width: 270,
                                      decoration: BoxDecoration(
                                        color: colorList[0],
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          context.pushReplacement('/',
                                              extra: authProvider
                                                  .loggedUser.userId);
                                        },
                                        backgroundColor: colorList[0],
                                        elevation: 10.0,
                                        child: Text("CONTINUAR",
                                            style: GoogleFonts.nunito(
                                                fontSize: 15,
                                                color: colorList[2],
                                                fontWeight: FontWeight.w800)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
