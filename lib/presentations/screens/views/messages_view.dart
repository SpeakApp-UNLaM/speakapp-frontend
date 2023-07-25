import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sp_front/providers/tts_provider.dart';

class MessagesView extends StatelessWidget {
  static const String name = 'messages';

  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextToSpeech(),
            TextToSpeech2(),
            TextToSpeech3()
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
                child: Text("NU"),
                onPressed: () => TtsProvider().speak("NU"))
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
                child: Text("BLA"),
                onPressed: () => TtsProvider().speak("BLA"))
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
                child: Text("DO"),
                onPressed: () => TtsProvider().speak("DO"))
          ],
        ),
      ),
    );
  }
}
