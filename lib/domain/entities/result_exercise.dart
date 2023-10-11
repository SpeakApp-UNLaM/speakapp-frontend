import 'package:sp_front/config/helpers/param.dart';
import 'package:sp_front/domain/entities/result_pair_images.dart';

class ResultExercise {
  TypeExercise type;
  String audio;
  int idTaskItem;
  List<ResultPairImages> pairImagesResult;
  ResultExercise(
      {required this.type,
      required this.audio,
      required this.pairImagesResult,
      required this.idTaskItem});
}
