import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'task_provider.dart';
import 'task.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final int? index;

  TaskForm({this.task, this.index});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String _description = '';
  DateTime _dueDate = DateTime.now();
  int _priority = 3;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    } else {
      _title = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              ListTile(
                title: Text('Due Date: ${DateFormat.yMd().format(_dueDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDueDate,
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                items: [
                  DropdownMenuItem(value: 1, child: Text('High')),
                  DropdownMenuItem(value: 2, child: Text('Medium')),
                  DropdownMenuItem(value: 3, child: Text('Low')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task newTask = Task(
        title: _title,
        description: _description,
        isCompleted: widget.task?.isCompleted ?? false,
        dueDate: _dueDate,
        priority: _priority,
      );

      if (widget.index == null) {
        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
      } else {
        Provider.of<TaskProvider>(context, listen: false).updateTask(widget.index!, newTask);
      }

      Navigator.pop(context);
    }
  }
}