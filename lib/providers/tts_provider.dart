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
    //TODO ver si se puede realizar la configuracion una sola vez
  }

  Future<void> speak(String text, double rate) async {
  
    if (_playing) await stop();
    if (text.isNotEmpty) {
      await _flutterTts
          .setLanguage('es-ES'); // Establece el idioma, en este caso, español.
      await _flutterTts.setVoice({"name": 'es-es-x-eea-network', "locale": 'es-ES'}); 

      await _flutterTts.setSpeechRate(
          rate); // creo que es la velocidad del hablado, no funciona en español :(
      await _flutterTts.setPitch(1.0);
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
