import 'package:get/get.dart';
import 'package:todo_app/view_models/controller/task_controller.dart';

class TaskControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(TaskController());
  }
}