/// Represents a journal entry with a unique ID, title, content, date, and type.
class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String type;

  /// Constructs a [JournalEntry] with the given properties.
  /// 
  /// Throws [AssertionError] if any required fields are empty, ensuring 
  /// that no invalid [JournalEntry] instances are created.
  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.type,
  }) : assert(id.isNotEmpty, 'ID cannot be empty'),
       assert(title.isNotEmpty, 'Title cannot be empty'),
       assert(content.isNotEmpty, 'Content cannot be empty'),
       assert(type == 'Regular' || type == 'Gratitude', 'Invalid type');

  /// Converts a [JournalEntry] instance into a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'date': date.toIso8601String(),
        'type': type,
      };

  /// Creates a [JournalEntry] from a JSON map.
  /// 
  /// Returns `null` if the JSON map is missing required fields or if data is invalid,
  /// providing basic error handling for malformed data.
  static JournalEntry? fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'];
      final title = json['title'];
      final content = json['content'];
      final date = DateTime.parse(json['date']);
      final type = json['type'];

      if (id == null || title == null || content == null || type == null) {
        return null; // Missing required field
      }

      return JournalEntry(
        id: id,
        title: title,
        content: content,
        date: date,
        type: type,
      );
    } catch (e) {
      // Log or handle the error appropriately in your app context
      return null; // Indicates a parsing or invalid data error
    }
  }
}
