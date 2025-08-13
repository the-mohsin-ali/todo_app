import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/task/user_task.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/services/shared_prefs.dart';

class TaskController extends GetxController{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var tasks = <UserTask>[].obs;
  var filteredTasks = <UserTask>[].obs;
  RxBool showSearch = false.obs;
  TextEditingController searchController = TextEditingController();
  StreamSubscription? _taskSubscription;

  @override
  void onInit(){
    super.onInit();
    fetchTasks();
    // _startListeningToTasks();
    ever(tasks, (_) => filterTasks(searchController.text)); 
  }

  @override
  void onClose(){
    super.onClose();
    _taskSubscription?.cancel();
  }

  // void _startListeningToTasks() async {
  //   final userId = await SharedPrefs.getUserId();
  //   if (userId == null) {
  //     if (kDebugMode) {
  //       print('User not logged in, clearing tasks');
  //     }
  //     Utils.snackBar('Error', 'User not logged in');
  //     tasks.clear();
  //     return;
  //   }
  //   if (kDebugMode) {
  //     print('Starting task stream for User ID: $userId');
  //   }

  //   await _taskSubscription?.cancel();
  //   _taskSubscription = _db.collection('tasks').where('userId', isEqualTo: userId).snapshots().listen((snapshot) {
  //     tasks.value = snapshot.docs.map((doc) => UserTask.fromFirebase(doc)).toList();
  //   },
  //   onError: (e) {
  //     if (kDebugMode) {
  //         print('Error fetching tasks: $e');
  //       }
  //       Utils.snackBar('Error', 'Failed to fetch tasks: $e');
  //       tasks.clear();
  //   } 
  //   );

  // }
  

  void fetchTasks()async{
    
    final userId = await SharedPrefs.getUserId();
    if(kDebugMode){
      print('fetching tasks for User ID: $userId');
    }
    if(userId == null){
      Utils.snackBar('Error', 'User not logged in');
      tasks.clear();
      return;
    }

    await _taskSubscription?.cancel();
    _taskSubscription = _db.collection('tasks').where('userId', isEqualTo: userId).snapshots().listen((snapshot) {
      tasks.value = snapshot.docs.map((doc) => UserTask.fromFirebase(doc)).toList();
    },
    onError: (e) {
      if (kDebugMode) {
          print('Error fetching tasks: $e');
        }
        Utils.snackBar('Error', 'Failed to fetch tasks: $e');
        tasks.clear();
    } 
    );
  }

  Future<void> addTask(UserTask task) async{
    try{
      final userId = await SharedPrefs.getUserId();
      if(userId == null){
        Utils.snackBar('Error', 'User not logged in');
        return;
      }
      final newTask = UserTask(
        id: '',
        userId: userId, 
        title: task.title, 
        description: task.description,
        dateTime: task.dateTime
      );
      final docRef = await _db.collection('tasks').add(newTask.toMap());
      await docRef.update({'id': docRef.id});
      Utils.snackBar('Success', 'Task added successfully');
      fetchTasks();
    }catch (e){
      Utils.snackBar('Error', 'Failed to add taskL $e');
    }
  } 

  Future<void> toggleTaskStatus(UserTask task) async {
    try{
      await _db.collection('tasks').doc(task.id).update({
        'isCompleted' : !task.isCompleted
      });
      int index = tasks.indexWhere((t)=> t.id == task.id);
      if (index != -1) {
        tasks[index].isCompleted = !task.isCompleted;
        tasks.refresh(); 
      }
    }catch(e){
      Utils.snackBar('Error', 'Failed to update status $e');
    }
  }

  Future<void> updateTask(UserTask task) async {
    try {
      await _db.collection('tasks').doc(task.id).update(task.toMap());
    } catch (e) {
      Utils.snackBar('Error', 'Failed to update task: $e');
    }
  }

  void deleteTask(String id) async {
    try {
      await _db.collection('tasks').doc(id).delete();
    } catch (e) {
      Utils.snackBar('Error', 'Failed to delete task: $e');
    }
  }

  List<UserTask> get completedTasks => tasks.where((task)=> task.isCompleted == true).toList();

  void toggleSearch(){
    showSearch.value = !showSearch.value;
    if(!showSearch.value){
      searchController.clear();
      filteredTasks.assignAll(tasks);
    }
  }

  void filterTasks(String query){
    if(query.isEmpty){
      filteredTasks.assignAll(tasks);
    }else{
      filteredTasks.assignAll(
        tasks.where((task)=>
        task.title.toLowerCase().contains(query.toLowerCase()))
      );
    }
  }
}