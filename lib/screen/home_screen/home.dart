import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listtodo/screen/login_screen/login.dart';
import 'package:listtodo/screen/task_screen/task.dart';
import 'package:listtodo/screen/task_screen/task_service.dart';
import 'package:listtodo/util/dialog_box.dart';
import 'package:listtodo/util/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService taskService = TaskService();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  DateTime? selectedDueDate;

  Future<void> signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void createNewTask() {
    _categoryController.clear();
    selectedDueDate = null;
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          taskController: _taskController,
          categoryController: _categoryController,
          initialDueDate: selectedDueDate,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
          onDueDateChanged: (newDate) {
            setState(() {
              selectedDueDate = newDate;
            });
          },
        );
      },
    );
  }

  Future<void> saveNewTask() async {
    if (_taskController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty) {
      Task newTask = Task(
        id: '',
        name: _taskController.text,
        category: _categoryController.text,
        completed: false,
        dueDate: selectedDueDate,
      );
      await taskService.addTask(newTask);
      _taskController.clear();
      _categoryController.clear();
      selectedDueDate = null;
      Navigator.of(context).pop();
    }
  }

  Future<void> checkBoxChanged(bool? value, Task task) async {
    Task updatedTask = Task(
      id: task.id,
      name: task.name,
      category: task.category,
      completed: value ?? false,
      dueDate: task.dueDate,
    );
    await taskService.updateTask(updatedTask);
  }

  Future<void> deleteTask(String taskId) async {
    await taskService.deleteTask(taskId);
  }

  void editTaskDialog(Task task) {
    _taskController.text = task.name;
    _categoryController.text = task.category;
    selectedDueDate = task.dueDate;

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          taskController: _taskController,
          categoryController: _categoryController,
          initialDueDate: selectedDueDate,
          onSave: () => editTask(task),
          onCancel: () => Navigator.of(context).pop(),
          onDueDateChanged: (newDate) {
            setState(() {
              selectedDueDate = newDate;
            });
          },
        );
      },
    );
  }

  Future<void> editTask(Task task) async {
    if (_taskController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty) {
      Task updatedTask = Task(
        id: task.id,
        name: _taskController.text,
        category: _categoryController.text,
        completed: task.completed,
        dueDate: selectedDueDate,
      );
      await taskService.updateTask(updatedTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Colors.blue.shade400,
        title: const Center(
          child: Text(
            "TO DO APP",
            selectionColor: Colors.black,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.blue.shade400,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: StreamBuilder<List<Task>>(
        stream: taskService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }
          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];
              return ToDoTile(
                taskName: task.name,
                categoryName: task.category,
                taskCompleted: task.completed,
                dueDate: task.dueDate,
                onChanged: (value) => checkBoxChanged(value, task),
                deleteFunction: (context) => deleteTask(task.id),
                onEdit: () => editTaskDialog(task),
              );
            },
          );
        },
      ),
    );
  }
}
