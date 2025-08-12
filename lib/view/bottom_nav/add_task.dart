import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task/user_task.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/res/components/round_button.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/controller/bottom_bar_controller.dart';
import 'package:todo_app/view_models/controller/task_controller.dart';

class AddTask extends StatelessWidget {
  AddTask({super.key});

  final RxBool checkbox = false.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDateTime;

    final taskController = Get.find<TaskController>();
    BottomBarController bottomBarController = Get.put(BottomBarController());
    TextEditingController dateTimeController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController desController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            bottomBarController.goToHomeTab();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Add Task",
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
          key: _formKey,
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
                controller: titleController,
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
                controller: desController,
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
                controller: dateTimeController,
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
                        selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        String formatted = DateFormat(
                          'd MMM y - h:mm a',
                        ).format(selectedDateTime!);
                        dateTimeController.text = formatted;
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
                      value: checkbox.value,
                      onChanged: (bool? value) {
                        checkbox.value = value ?? false;
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              RoundButton(
                loading: false,
                title: "Add Task",
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    final taskId = DateTime.now().millisecondsSinceEpoch
                        .toString();
                    final task = UserTask(
                      id: taskId,
                      title: titleController.text,
                      description: desController.text,
                      dateTime: selectedDateTime!,
                      isCompleted: false,
                    );
                    await taskController.addTask(task);
                    Utils.snackBar("Success", "Task added successfully");
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
