class Achievement {
  int? id;
  String title;
  String description;
  bool isUnlocked;

  Achievement({
    this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
  });

  factory Achievement.fromMap(Map<String, dynamic> json) => Achievement(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        isUnlocked: json['isUnlocked'] == 1,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isUnlocked': isUnlocked ? 1 : 0,
    };
  }

  Achievement copy({int? id, String? title, String? description, bool? isUnlocked}) => Achievement(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    isUnlocked: isUnlocked ?? this.isUnlocked,
  );
}
