import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task/user_task.dart';
import 'package:todo_app/res/colors/app_colors.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.edit, color: AppColors.subtitle),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            task.description ?? '',
            style: TextStyle(color: AppColors.subtitle, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('h:mm a d MMM, yyyy').format(task.dateTime),
                style: const TextStyle(fontSize: 12, color: AppColors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Mark as completed',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: task.isCompleted
                          ? AppColors.green
                          : AppColors.subtitle,
                    ),
                  ),
                  const SizedBox(width: 8),
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
