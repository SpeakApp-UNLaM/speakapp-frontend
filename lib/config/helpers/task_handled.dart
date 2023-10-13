import 'package:sp_front/config/helpers/param.dart';
import '../../domain/entities/task.dart';
import '../../models/task_model.dart';
import 'api.dart';

class TaskHandled {
  Future<List<Task>> fetchData({required int idPatient}) async {
    final response = await Api.get("${Param.getTasks}/$idPatient");
    List<Task> lst = [];
    for (var element in response) {
      lst.add(TaskModel.fromJson(element).toTaskEntity());
    }
    return lst;
  }
}
