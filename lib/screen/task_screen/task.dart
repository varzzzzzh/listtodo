import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String name;
  String category;
  bool completed;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.name,
    required this.category,
    required this.completed,
    this.dueDate,
  });

  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      completed: data['completed'] ?? false,
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'completed': completed,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    };
  }
}
