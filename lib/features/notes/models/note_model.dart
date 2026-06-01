class NoteModel {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final String? category; // e.g., 'AI/ML', 'Flutter', 'Deep Learning'
  final String? description;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.category,
    this.description,
  });

  factory NoteModel.fromMarkdown({
    required String id,
    required String content,
    required Map<String, dynamic> metadata,
  }) {
    return NoteModel(
      id: id,
      title: metadata['title'] as String? ?? 'Untitled',
      content: content,
      author: metadata['author'] as String? ?? 'TokenX',
      createdAt: _parseDate(metadata['date'] ?? metadata['createdAt']),
      updatedAt: _parseDate(metadata['updatedAt']),
      tags: _parseList(metadata['tags']),
      category: metadata['category'] as String?,
      description: metadata['description'] as String?,
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static List<String> _parseList(dynamic list) {
    if (list == null) return [];
    if (list is List) {
      return list.map((e) => e.toString()).toList();
    }
    if (list is String) {
      return list.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }
}
