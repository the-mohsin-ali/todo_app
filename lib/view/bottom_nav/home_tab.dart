import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/controller/auth_controller.dart';
import 'package:todo_app/view_models/controller/task_controller.dart';
import 'package:todo_app/view_models/services/shared_prefs.dart';

class HomeTab extends GetResponsiveView<TaskController> {
  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) {
    //   print('userId: ${SharedPrefs.getUserId()}');
    // }

    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: TextButton(
            child: Text('Logout'),
            onPressed: () {
              authController.logout();
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFEADDFF),
                        radius: 30,
                        child: Text(
                          "A",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: AppColors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          controller.toggleSearch();
                        },
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        color: AppColors.black,
                        onPressed: () {},
                        icon: Icon(Icons.notifications_none_outlined, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
              Obx(
                () => controller.showSearch.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: 'search tasks...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                30,
                              ), // <-- More circular border
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            controller.filterTasks(value);
                          },
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello Emmanuel 👋',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Let\'s get started keeping your tasks organized',
                    style: TextStyle(fontSize: 16, color: AppColors.subtitle),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Expanded(
                child: Obx(
                  () => controller.tasks.isEmpty && controller.filteredTasks.isEmpty ? 
                  Center(child: Text('No tasks yet', style: TextStyle(color: AppColors.black, fontSize: 30),),) 
                  : ListView.builder(
                    itemCount: controller.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = controller.filteredTasks[index];
                      return Utils.buildTaskCard(task, controller);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
