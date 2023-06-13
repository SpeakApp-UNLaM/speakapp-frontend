import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Param {
  //10.0.2.2 IP especial para emuladores, que mapea la IP del HOST el cual está ejecutando (equivalente a LOCALHOST)
  static const urlServer = "http://10.0.2.2:9292/speak-app/";
  static const postTranscription = "/speech-recognition/transcription";
  static const getCareers = "/careers";
  static const getExercises = "/exercises";
  static const getPending = "/pending/1";
  static const getGroupExercises = "/groupExercises";
  static const modelWhisper = "whisper-1";

  static void showToast(String response) {
    Fluttertoast.showToast(
      msg: 'Error: $response', // Mensaje de la excepción
      toastLength: Toast
          .LENGTH_LONG, // Duración del toast (Toast.LENGTH_LONG o Toast.LENGTH_SHORT)
      gravity: ToastGravity
          .CENTER, // Posición del toast (ToastGravity.TOP, ToastGravity.CENTER, ToastGravity.BOTTOM)
      backgroundColor: Colors.red, // Color de fondo del toast
      textColor: Colors.white, // Color del texto del toast
    );
  }
}
