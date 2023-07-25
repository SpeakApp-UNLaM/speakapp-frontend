import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsProvider extends ChangeNotifier {
  FlutterTts _flutterTts = FlutterTts();

  bool _playing = false;

  bool get playing => _playing;

  TtsProvider() {
    _initTts();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    // Puedes personalizar las configuraciones de TTS aquí si lo deseas.
  }

  Future<void> speak(String text) async {
    if (_playing) await stop();
    if (text.isNotEmpty) {
      await _flutterTts.setLanguage('es'); // Establece el idioma, en este caso, español.
      await _flutterTts.setSpeechRate(1.0); // Puedes ajustar la velocidad del habla si lo deseas.
      await _flutterTts.setPitch(1.0); // Puedes ajustar el tono del habla si lo deseas.
      await _flutterTts.speak(text);
      _playing = true;
      notifyListeners();
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _playing = false;
    notifyListeners();
  }
}