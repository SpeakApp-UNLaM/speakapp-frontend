import 'dart:convert';

import '../domain/entities/transcription.dart';

TranscriptionModel transcriptionModelFromJson(String str) =>
    TranscriptionModel.fromJson(json.decode(str));

String transcriptionModelToJson(TranscriptionModel data) =>
    json.encode(data.toJson());

class TranscriptionModel {
  final String text;

  TranscriptionModel({
    required this.text,
  });

  factory TranscriptionModel.fromJson(Map<String, dynamic> json) =>
      TranscriptionModel(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
  Transcription toTranscriptionEntity() => Transcription(transcription: text);
}
