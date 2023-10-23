import 'package:sp_front/config/helpers/param.dart';
import 'package:sp_front/models/phoneme_model.dart';
import '../../domain/entities/phoneme.dart';
import '../../domain/entities/task.dart';
import '../../models/task_model.dart';
import 'api.dart';

class TaskHandled {
  Future<List<Task>> fetchData({required int idPatient}) async {
    List<Task> lst = [];
    final response = await Api.get("${Param.getTasks}/$idPatient");
    if (response != null) {
      for (var element in response) {
        lst.add(TaskModel.fromJson(element).toTaskEntity());
      }
    }

    return lst;
  }

  Future<List<Phoneme>> fetchAllPhonemes() async {
    List<Phoneme> lst = [];
    final response = await Api.get(Param.getAllPhonemes);
    if (response != null) {
      for (var element in response) {
        lst.add(PhonemeModel.fromJson(element).toPhonemeEntity());
      }
    }

    return lst;
  }

  Future<List<Phoneme>> fetchAvailablePhonemes() async {
    List<Phoneme> lst = [];
    final response = await Api.get(Param.getAvailablesPhonemes);
    if (response != null) {
      for (var element in response) {
        lst.add(PhonemeModel.fromJson(element).toPhonemeEntity());
      }
    }

    return lst;
  }
}
