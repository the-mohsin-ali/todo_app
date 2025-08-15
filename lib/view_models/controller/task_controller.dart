import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/task/user_task.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/controller/auth_controller.dart';
import 'package:todo_app/view_models/services/shared_prefs.dart';

class TaskController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var tasks = <UserTask>[].obs;
  var filteredTasks = <UserTask>[].obs;

  Rxn<UserTask> editingTask = Rxn<UserTask>();

  RxBool showSearch = false.obs;
  TextEditingController searchController = TextEditingController();
  final RxBool isLoading = true.obs;
  StreamSubscription<QuerySnapshot>? _taskSubscription;
  final AuthController authController = Get.find<AuthController>();

  TextEditingController dateTimeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  final RxBool checkbox = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? selectedDateTime;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
    ever(tasks, (_) => filterTasks(searchController.text));
  }

  @override
  void onClose() {
    super.onClose();
    _taskSubscription?.cancel();
  }

  void fetchTasks() async {
    final userId = await SharedPrefs.getUserId();
    if (kDebugMode) {
      print('fetching tasks for User ID: $userId');
    }
    if (userId == null) {
      Utils.snackBar('Error', 'User not logged in');
      tasks.clear();
      return;
    }

    await _taskSubscription?.cancel();
    _taskSubscription = _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
          (snapshot) {
            if (kDebugMode) {
              print('snapshot received with ${snapshot.docs.length} tasks');
            }
            tasks.value =
                snapshot.docs.map((doc) => UserTask.fromFirebase(doc)).toList()
                  ..sort((a, b) {
                    int compareCompleted = (a.isCompleted ? 1 : 0).compareTo(
                      b.isCompleted ? 1 : 0,
                    );
                    if (compareCompleted != 0) {
                      return compareCompleted;
                    }
                    return a.dateTime.compareTo(b.dateTime);
                  });
            isLoading.value = false;
          },
          onError: (e) {
            if (kDebugMode) {
              print('Error fetching tasks: $e');
            }
            Utils.snackBar('Error', 'Failed to fetch tasks: $e');
            isLoading.value = false;
            tasks.clear();
            if (e.toString().contains('Network') ||
                e.toString().contains('aborted')) {
              Future.delayed(Duration(seconds: 3), fetchTasks);
            }
          },
          onDone: () {
            if (kDebugMode) {
              print('Fetch tasks stream closed');
            }
            isLoading.value = false;
          },
        );
  }

  Future<void> addTask(UserTask task) async {
    try {
      final userId = await SharedPrefs.getUserId();
      if (userId == null) {
        Utils.snackBar('Error', 'User not logged in');
        return;
      }
      final newTask = UserTask(
        id: '',
        userId: userId,
        title: task.title,
        description: task.description,
        dateTime: task.dateTime,
      );
      final docRef = await _db.collection('tasks').add(newTask.toMap());
      await docRef.update({'id': docRef.id});
      Utils.snackBar('Success', 'Task added successfully');
      fetchTasks();
    } catch (e) {
      Utils.snackBar('Error', 'Failed to add taskL $e');
    }
  }

  Future<void> toggleTaskStatus(UserTask task) async {
    try {
      await _db.collection('tasks').doc(task.id).update({
        'isCompleted': !task.isCompleted,
      });
      int index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index].isCompleted = !task.isCompleted;
        tasks.refresh();
      }
    } catch (e) {
      Utils.snackBar('Error', 'Failed to update status $e');
    }
  }

  void setEditingTask(UserTask task) {
    editingTask.value = task;
  }

  void clearEditingTask() {
    editingTask.value = null;
    titleController.clear();
    desController.clear();
    dateTimeController.clear();
  }

  Future<void> updateTask() async {
    try {
      isLoading.value = true;
      if (kDebugMode) {
        print(
          'Updating task with id: ${editingTask.value?.id}, data: ${editingTask.value?.toMap()}',
        );
      }
      await _db
          .collection('tasks')
          .doc(editingTask.value?.id)
          .update(editingTask.value!.toMap());
      Utils.snackBar('Success', 'Task updated successfully');
      int index = tasks.indexWhere((t) => t.id == editingTask.value?.id);
      if (index != -1) {
        tasks[index] = editingTask.value!;
        tasks.refresh();
      }
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.message}');
      Utils.snackBar('Error', 'Firestore failed: ${e.message}');
    } catch (e) {
      Utils.snackBar('Error', 'Failed to update task: $e');
      print('Error updating task: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteTask(UserTask task) async {
    final currentUser = await SharedPrefs.getUserId();

    print('currentUser value: $currentUser');
    print('task.userId value: ${task.userId}');
    if (task.userId != currentUser) {
      Utils.snackBar('Error', 'You are not authorized to delete this task');
      return;
    }
    try {
      await _db.collection('tasks').doc(task.id).delete();
      tasks.removeWhere((t) => t.id == task.id);
      tasks.refresh();
      Utils.snackBar('Success', 'Task deleted successfully');
    } catch (e) {
      Utils.snackBar('Error', 'Failed to delete task: $e');
      print('Error deleting task: $e');
    }
  }

  List<UserTask> get completedTasks =>
      tasks.where((task) => task.isCompleted == true).toList();

  void toggleSearch() {
    showSearch.value = !showSearch.value;
    if (!showSearch.value) {
      searchController.clear();
      filteredTasks.assignAll(tasks);
    }
  }

  void filterTasks(String query) {
    if (query.isEmpty) {
      filteredTasks.assignAll(tasks);
    } else {
      filteredTasks.assignAll(
        tasks.where(
          (task) => task.title.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }
}
