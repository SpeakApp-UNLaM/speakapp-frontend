import 'dart:convert';

import '../domain/entities/rfi.dart';

List<RFIExerciseModel> RFIExerciseModelFromJson(String str) =>
    List<RFIExerciseModel>.from(
        json.decode(str).map((x) => RFIExerciseModel.fromJson(x)));

String RFIExerciseModelToJson(List<RFIExerciseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RFIExerciseModel {
  final int idRfi;
  final String imageData;
  final String name;
  final String status;

  RFIExerciseModel({
    required this.idRfi,
    required this.imageData,
    required this.name,
    required this.status,
  });

  factory RFIExerciseModel.fromJson(Map<String, dynamic> json) =>
      RFIExerciseModel(
        idRfi: json["idRfi"],
        imageData: json["imageData"],
        name: json["name"],
        status: json["status"] ?? "pending",
      );

  RFI toRFIEntity() =>
      RFI(idRfi: idRfi, imageData: imageData, name: name, status: status);

  Map<String, dynamic> toJson() => {
        "idRfi": idRfi,
        "imageData": imageData,
        "name": name,
        "status": status,
      };
}
