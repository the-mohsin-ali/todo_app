import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/controller/task_controller.dart';

class TaskCompleted extends GetResponsiveView<TaskController> {
  TaskCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Completed Tasks',
                    style: TextStyle(color: AppColors.black, fontSize: 30),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 30),
              Expanded(
                child: Obx(() {
                  final completed = controller.completedTasks;
                  if(completed.isEmpty) return Center(child: Text('No Completed Tasks', style: TextStyle(color: AppColors.black, fontSize: 30),));
                  return ListView.builder(
                    itemCount: completed.length,
                    itemBuilder: (context, index) {
                      final task = completed[index];
                      return Utils.buildTaskCard(task, controller);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
