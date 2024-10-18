import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController taskController;
  final TextEditingController categoryController;
  final DateTime? initialDueDate;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final Function(DateTime) onDueDateChanged;

  const DialogBox({
    super.key,
    required this.taskController,
    required this.categoryController,
    required this.onSave,
    required this.onCancel,
    required this.onDueDateChanged,
    this.initialDueDate,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDueDate ?? DateTime.now();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDueDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade100,
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Add/Edit Task",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 17),
            TextField(
              controller: widget.taskController,
              decoration: const InputDecoration(
                hintText: "Enter Task Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 7),
            TextField(
              controller: widget.categoryController,
              decoration: const InputDecoration(
                hintText: "Enter Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),
            // SizedBox(
            //   width: 300,
            //   height: 50,
            //   child: OutlinedButton(
            //     onPressed: () => _pickDate(context),
            //     style: OutlinedButton.styleFrom(
            //       backgroundColor: Colors.blue[100],
            //       side: const BorderSide(
            //         color: Colors.black,
            //         width: 0.6,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(7.5),
            //       ),
            //     ),
            //     child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: Text(
            //         _selectedDate == null
            //             ? "Select Date"
            //             : "Selected date: ${_selectedDate!.toLocal()}"
            //                 .split(' ')[0],
            //         style: const TextStyle(color: Colors.black),
            //       ),
            //     ),
            //   ),
            // ),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 217, 103, 237),
              ),
              child: Text(
                _selectedDate == null
                    ? "Select Date "
                    : "Select Date : ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: widget.onCancel,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200]),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                  ),
                  child: const Text(
                    " Save ",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
