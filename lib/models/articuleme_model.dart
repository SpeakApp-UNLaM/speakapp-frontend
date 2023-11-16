import 'package:sp_front/config/helpers/param.dart';

import '../domain/entities/category.dart';

class ArticulemeModel {
  int idArticulation;
  String namePhoneme;
  String imageData;

  ArticulemeModel(
      {required this.idArticulation, required this.namePhoneme, required this.imageData});

  factory ArticulemeModel.fromJson(Map<String, dynamic> json) => ArticulemeModel(
        idArticulation: json["idArticulation"],
        namePhoneme: json["namePhoneme"],
        imageData: json["imageData"],
      );

  Map<String, dynamic> toJson() =>
      {"idArticulation": idArticulation, "namePhoneme": namePhoneme, "imageData": imageData};


}
