class Goal {
  int? id;
  String title;
  String description;
  int progress;
  bool isCompleted;
  
  Goal({this.id, required this.title, required this.description, this.progress = 0, this.isCompleted = false});

  factory Goal.fromMap(Map<String, dynamic> json) => Goal(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    progress: json['progress'],
    isCompleted: json['isCompleted'] == 1,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'progress': progress,
    'isCompleted': isCompleted ? 1 : 0,
  };

  Goal copy({int? id, String? title, String? description, int? progress, bool? isCompleted}) => Goal(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    progress: progress ?? this.progress,
    isCompleted: isCompleted ?? this.isCompleted,
  );
}
