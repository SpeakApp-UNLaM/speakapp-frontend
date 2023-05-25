import 'package:flutter/material.dart';

abstract class Exercises {
  Image img;
  String name;
  String letra;
  Exercises({required this.img, required this.name, required this.letra});

  Image getImage() => img;
  String getName() => name;
  String getLetra() => letra;
}
