import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart';

class TaskService {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    await taskCollection.add(task.toFirestore());
  }

  Future<void> updateTask(Task task) async {
    await taskCollection.doc(task.id).update(task.toFirestore());
  }

  Future<void> deleteTask(String taskId) async {
    await taskCollection.doc(taskId).delete();
  }

  Stream<List<Task>> getTasks() {
    return taskCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
