import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/res/components/round_button.dart';
import 'package:todo_app/utils/global_variable.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/controller/task_controller.dart';

class HomeTab extends GetResponsiveView<TaskController> {
  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    String firstLetter = GlobalVariable.userName.isNotEmpty
        ? GlobalVariable.userName[0].toUpperCase()
        : 'A';

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.subtitle, 
              ),
              accountName: Text(GlobalVariable.userName),
              accountEmail: Text(GlobalVariable.userEmail),
              currentAccountPicture: CircleAvatar(child: Text(firstLetter)),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundButton(
                    loading: false,
                    onPress: () {
                      controller.authController.logout();
                    },
                    title: 'Logout',
                  ),
                ),
              ),
            ),
          ],
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
                          firstLetter,
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
                              borderRadius: BorderRadius.circular(30),
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
                  'Hello ${GlobalVariable.userName} 👋',
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
                  () => controller.isLoading.value
                      ? Center(
                          child: Text(
                            'No tasks yet',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 30,
                            ),
                          ),
                        )
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
