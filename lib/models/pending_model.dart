import 'dart:convert';
import '../domain/entities/pending.dart';

List<PendingModel> pendingModelFromJson(String str) => List<PendingModel>.from(
    json.decode(str).map((x) => PendingModel.fromJson(x)));

String pendingModelToJson(List<PendingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PendingModel {
  final int idUsr;
  final int idExercise;
  final int idGroupExercise;

  PendingModel({
    required this.idUsr,
    required this.idExercise,
    required this.idGroupExercise,
  });

  factory PendingModel.fromJson(Map<String, dynamic> json) => PendingModel(
        idUsr: json["idUsr"],
        idExercise: json["idExercise"],
        idGroupExercise: json["idGroupExercise"],
      );

  Map<String, dynamic> toJson() => {
        "idUsr": idUsr,
        "idExercise": idExercise,
        "idGroupExercise": idGroupExercise,
      };
  Pending toPendingEntity() => Pending(
        idUsr: idUsr,
        idExercise: idExercise,
        idGroupExercise: idGroupExercise,
      );
}
