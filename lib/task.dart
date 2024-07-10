class Task {
  String title;
  String description;
  bool isCompleted;
  DateTime dueDate;
  int priority; // 1: High, 2: Medium, 3: Low

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.dueDate,
    this.priority = 3,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'] ?? 3,
    );
  }
}
