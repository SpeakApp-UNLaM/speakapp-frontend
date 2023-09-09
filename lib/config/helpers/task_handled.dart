import 'package:sp_front/config/helpers/param.dart';
import '../../domain/entities/task.dart';
import '../../models/task_model.dart';
import 'api.dart';

class TaskHandled {
  Future<List<Task>> fetchData() async {
    final response = await Api.get("${Param.getTasks}/1");
    List<Task> lst = [];
    for (var element in response) {
      lst.add(TaskModel.fromJson(element).toTaskEntity());
    }
    return lst;
  }
}
