class Habit {
  int? id;
  String title;
  int streak;
  bool isCompletedToday;

  Habit({this.id, required this.title, this.streak = 0, this.isCompletedToday = false});

  factory Habit.fromMap(Map<String, dynamic> json) => Habit(
        id: json['id'],
        title: json['title'],
        streak: json['streak'],
        isCompletedToday: json['isCompletedToday'] == 1,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'streak': streak,
      'isCompletedToday': isCompletedToday ? 1 : 0,
    };
  }

  Habit copy({int? id, String? title, int? streak, bool? isCompletedToday}) => Habit(
    id: id ?? this.id,
    title: title ?? this.title,
    streak: streak ?? this.streak,
    isCompletedToday: isCompletedToday ?? this.isCompletedToday,
  );
}
