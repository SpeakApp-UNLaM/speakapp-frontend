import 'package:sp_front/domain/entities/result_pair_images.dart';

class ResultPairImagesModel {
  int idImage;
  String nameImage;
  ResultPairImagesModel({required this.idImage, required this.nameImage});

  Map<String, dynamic> toJson() => {
        "idImage": idImage,
        "name": nameImage,
      };

  static ResultPairImagesModel resultPairImagesToModel(ResultPairImages e) =>
      ResultPairImagesModel(idImage: e.idImage, nameImage: e.nameImage);
}
