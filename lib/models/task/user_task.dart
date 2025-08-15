import 'package:cloud_firestore/cloud_firestore.dart';

class UserTask {
  String id;
  String userId;
  String title;
  String? description;
  DateTime dateTime;
  bool isCompleted;

  UserTask({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.dateTime,
    this.isCompleted = false,
  });

  factory UserTask.fromFirebase(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return UserTask(
      id: doc.id,
      userId: data['userId'], 
      title: data['title'],
      description: data['description'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false, 
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate( dateTime ),
      'isCompleted': isCompleted,
    };
  }

}