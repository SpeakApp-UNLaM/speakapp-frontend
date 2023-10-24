import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sp_front/presentations/messages_screen.dart';
import 'package:sp_front/providers/tts_provider.dart';

class MessagesView extends StatefulWidget {
  static const String name = 'messages';
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesView();
}

class _MessagesView extends State<MessagesView> with TickerProviderStateMixin {
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

class TextToSpeech extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
                child: Text("NU"), onPressed: () => TtsProvider().speak("NU", 0.5))
          ],
        ),
      ),
    );
  }
}

class TextToSpeech2 extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
                child: Text("BLA"), onPressed: () => TtsProvider().speak("BLA", 0.5))
          ],
        ),
      ),
    );
  }
}

class TextToSpeech3 extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
                child: Text("DO"), onPressed: () => TtsProvider().speak("DO", 0.5))
          ],
        ),
      ),
    );
  }
}
