class ImageExerciseModel {
  String name;
  String imageData;
  List<String> dividedName;

  ImageExerciseModel({
    required this.name,
    required this.imageData,
    required this.dividedName,
  });

  factory ImageExerciseModel.fromJson(Map<String, dynamic> json) {
    return ImageExerciseModel(
      name: json["name"],
      imageData: json["imageData"] ?? "",
      dividedName: (json["dividedName"] as String?)?.split('-') ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageData": imageData,
        "dividedName": dividedName,
      };

  List<String> getSyllables() {
    return dividedName;
  }
}
