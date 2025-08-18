import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task/user_task.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/view_models/controller/bottom_bar_controller.dart';
import 'package:todo_app/view_models/controller/task_controller.dart';

class Utils {
  static InputDecoration inputDecoration({
    required String title,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return InputDecoration(
      fillColor: AppColors.cardColor,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      hintText: title,
      filled: true,
      suffixIcon: suffixIcon != null
          ? GestureDetector(onTap: onTap, child: Icon(suffixIcon))
          : null,
    );
  }

  static snackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.black,
      colorText: AppColors.primary,
    );
  }

  static buildTaskCard(UserTask task, TaskController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8.sp,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                color: AppColors.cardColor,
                icon: const Icon(Icons.more_vert, color: AppColors.subtitle),
                onSelected: (String choice) {
                  if (choice == 'Update') {
                    controller.setEditingTask(task);
                    controller.titleController.text = task.title;
                    controller.desController.text = task.description ?? '';
                    controller.dateTimeController.text = task.dateTime.toString();
                    controller.selectedDateTime = task.dateTime;
                    print('Update action triggered ');
                    Get.find<BottomBarController>().selectedIndex.value = 1;
                  } else if (choice == 'delete') {
                    controller.deleteTask(task);
                    print('Delete action triggered');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem(child: Text('Update'), value: 'Update'),
                  PopupMenuItem(child: Text('Delete'), value: 'delete'),
                ],
              ),
            ],
          ),
          4.verticalSpace,
          Text(
            task.description ?? '',
            style: TextStyle(color: AppColors.subtitle, fontSize: 14.sp),
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('h:mm a d MMM, yyyy').format(task.dateTime),
                style: TextStyle(fontSize: 11.sp, color: AppColors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Mark as completed',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: task.isCompleted
                          ? AppColors.green
                          : AppColors.subtitle,
                    ),
                  ),
                  8.horizontalSpace,
                  Checkbox(
                    activeColor: AppColors.green,
                    value: task.isCompleted,
                    onChanged: (_) => controller.toggleTaskStatus(task),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
