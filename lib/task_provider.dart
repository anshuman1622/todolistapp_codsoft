import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void updateTask(int index, Task task) {
    _tasks[index] = task;
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    saveTasks();
    notifyListeners();
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasks = _tasks.map((task) => json.encode(task.toMap())).toList();
    await prefs.setStringList('tasks', tasks);
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? tasks = prefs.getStringList('tasks');
    if (tasks != null) {
      _tasks = tasks.map((task) => Task.fromMap(json.decode(task))).toList();
    }
    notifyListeners();
  }
}
