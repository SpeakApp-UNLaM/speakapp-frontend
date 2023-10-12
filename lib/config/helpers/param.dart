import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum TypeExercise {
  speak,
  multiple_match_selection, // ignore: constant_identifier_names
  minimum_pairs_selection, // ignore: constant_identifier_names
  multiple_selection, // ignore: constant_identifier_names
  single_selection_syllable, // ignore: constant_identifier_names
  order_syllable, // ignore: constant_identifier_names
  single_selection_word, // ignore: constant_identifier_names
  consonantal_syllable, // ignore: constant_identifier_names
}

enum Categories { syllable, word, phrase }

class Param {
  //10.0.2.2 IP especial para emuladores, que mapea la IP del HOST el cual está ejecutando (equivalente a LOCALHOST)
  //Si utiliza el celular FISICO para debugging, utilizar la IP de la RED DEL PC (ipconfig 192.168.1.XX) 192.168.1.33

  static const urlServer = "http://192.168.1.33:9292/speak-app/";
  static const postTranscription = "/speech-recognition/transcription";
  static const postRfi = "/rfi";
  static const getRfi = "/rfi";
  static const getCareers = "/careers";
  static const getExercisesCustom = "/tasks/generate-custom";
  static const getExercises = "/tasks/items";
  static const getTasks = "/tasks/";
  static const getPending = "/pending/1";
  static const getGroupExercises = "/groupExercises";
  static const modelWhisper = "whisper-1";
  static const postLogin = "/auth/signin";
  static const postSaveResultExercises = "/resolve-exercises";
  static const tamImages = 120.0;
  static const deleteTask = "/tasks/";
  static const getPatients = "/patients";
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

  static TypeExercise stringToEnumTypeExercise(String value) {
    return TypeExercise.values
        .firstWhere((element) => element.toString() == 'TypeExercise.$value');
  }

  static Map<Categories, String> categoriesDescriptions = {
    Categories.syllable: "Sílaba",
    Categories.word: "Palabra",
    Categories.phrase: "Frases"
  };

  static Categories stringToEnumCategories(String value) {
    return Categories.values
        .firstWhere((element) => element.toString() == 'Categories.$value');
  }
}
