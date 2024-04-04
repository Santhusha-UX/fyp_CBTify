class Task {
  int? id;
  String title;
  String? description;
  String? dueDate;
  bool isCompleted;
  int priority;

  Task({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    this.priority = 1,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dueDate: json['dueDate'],
        isCompleted: json['isCompleted'] == 1,
        priority: json['priority'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority,
    };
  }

  Task copy({int? id, String? title, String? description, String? dueDate, bool? isCompleted, int? priority}) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    dueDate: dueDate ?? this.dueDate,
    isCompleted: isCompleted ?? this.isCompleted,
    priority: priority ?? this.priority,
  );
}
