import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final String categoryName;
  final bool taskCompleted;
  final DateTime? dueDate;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final VoidCallback onEdit;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.categoryName,
    required this.taskCompleted,
    this.dueDate,
    required this.onChanged,
    required this.deleteFunction,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDueDate = dueDate != null
        ? "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}"
        : "No date selected";
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteFunction?.call(context);
              },
              icon: Icons.delete,
              backgroundColor: const Color.fromARGB(255, 236, 85, 100),
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        decoration:
                            taskCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      categoryName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDueDate,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
