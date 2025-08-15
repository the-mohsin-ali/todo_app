import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task/user_task.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/res/components/round_button.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/controller/bottom_bar_controller.dart';
import 'package:todo_app/view_models/controller/task_controller.dart';

class AddTask extends GetResponsiveView<TaskController> {
  AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          controller.editingTask.value != null ? "Edit Task" : "Add Task",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Task title",
                  style: TextStyle(color: AppColors.black, fontSize: 15),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: controller.titleController,
                decoration: Utils.inputDecoration(title: 'eg buy a bike'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter task title' : null,
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Task description",
                  style: TextStyle(color: AppColors.black, fontSize: 15),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: controller.desController,
                decoration: Utils.inputDecoration(title: ''),
                maxLines: 4,
                // validator: (value) => value == null || value.isEmpty ? 'Enter task description' : null,
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Set a deadline",
                  style: TextStyle(color: AppColors.black, fontSize: 15),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: controller.dateTimeController,
                readOnly: true,
                decoration: Utils.inputDecoration(
                  title: 'Select date and time',
                  suffixIcon: Icons.arrow_drop_down,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        controller.selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        String formatted = DateFormat(
                          'd MMM y - h:mm a',
                        ).format(controller.selectedDateTime!);
                        controller.dateTimeController.text = formatted;
                      }
                    }
                  },
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter task date and time'
                    : null,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Set as priority",
                    style: TextStyle(color: AppColors.black, fontSize: 18),
                  ),
                  Obx(
                    () => Checkbox(
                      activeColor: AppColors.secondary,
                      value: controller.checkbox.value,
                      onChanged: (bool? value) {
                        controller.checkbox.value = value ?? false;
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              RoundButton(
                loading: false,
                title: controller.editingTask.value != null
                    ? "Update Task"
                    : "Add Task",
                onPress: () async {
                  if (controller.formKey.currentState!.validate()) {
                    if (controller.editingTask.value != null) {
                      controller.editingTask.value!.title =
                          controller.titleController.text;
                      controller.editingTask.value!.description =
                          controller.desController.text;
                      controller.editingTask.value!.dateTime =
                          controller.selectedDateTime!;

                      print(
                        'value in editing task: ${controller.editingTask.value}',
                      );
                      await controller.updateTask();
                    } else {
                      final taskId = '';
                      final task = UserTask(
                        id: taskId,
                        title: controller.titleController.text,
                        description: controller.desController.text,
                        dateTime: controller.selectedDateTime!,
                        isCompleted: false,
                        userId: '',
                      );

                      await controller.addTask(task);
                    }

                    BottomBarController bottomBarController =
                        Get.find<BottomBarController>();
                    controller.clearEditingTask();
                    bottomBarController.goToHomeTab();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
