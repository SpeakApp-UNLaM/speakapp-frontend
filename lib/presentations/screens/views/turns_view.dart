import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sp_front/presentations/messages_screen.dart';
import 'package:sp_front/providers/tts_provider.dart';

class TurnsView extends StatefulWidget {
  static const String name = 'messages';
  const TurnsView({super.key});

  @override
  State<TurnsView> createState() => _TurnsView();
}

class _TurnsView extends State<TurnsView> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: /*const ChatPage(),*/
       Center(
        child: Column(
          children: [
            Text("COMING SOON - NOVIEMBRE 2023",
                style: Theme.of(context).textTheme.headlineMedium),
            Lottie.asset(
              'assets/animations/congrats.json',
              controller: _controller,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ],
        ),
      ),
    );
  }
}


