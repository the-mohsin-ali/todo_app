import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/task/user_task.dart';
import 'package:todo_app/utils/utils.dart';

class TaskController extends GetxController{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var tasks = <UserTask>[].obs;
  var filteredTasks = <UserTask>[].obs;
  RxBool showSearch = false.obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit(){
    super.onInit();
    fetchTasks();
    ever(tasks, (_) => filterTasks(searchController.text)); 
  }
  

  void fetchTasks(){
    _db.collection('tasks').snapshots().listen((snapshot){
      tasks.value = snapshot.docs.map((doc) => UserTask.fromFirebase(doc)).toList();
    });
  }

  Future<void> addTask(UserTask task) async{
    try{
      await FirebaseFirestore.instance.collection('tasks').doc(task.id).set(task.toMap());
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