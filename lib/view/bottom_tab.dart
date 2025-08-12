import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/view/bottom_nav/add_task.dart';
import 'package:todo_app/view/bottom_nav/home_tab.dart';
import 'package:todo_app/view/bottom_nav/task_completed.dart';
import 'package:todo_app/view_models/controller/bottom_bar_controller.dart';

class BottomTab extends StatelessWidget {
  const BottomTab({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBarController bottomBarController = Get.put(BottomBarController());

    final List<Widget> pages = [HomeTab(), AddTask(), TaskCompleted()];

    return Scaffold(
      body: Obx(() => pages[bottomBarController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Add Task',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Task'),
          ],
          onTap: bottomBarController.changeTabIndex,
          currentIndex: bottomBarController.selectedIndex.value,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
