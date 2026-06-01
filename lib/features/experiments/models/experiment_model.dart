class ExperimentModel {
  final String id;
  final String title;
  final String description;
  final String author;
  final List<String> tags; // e.g., ['ML', 'LLM', 'Classification']
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final String? concepts; // Concepts used, separated by comma
  final String? imagePath; // Optional: gradient bg or specific image
  final String githubLink;
  final String notebookName; // e.g., 'mnist.ipynb'
  final DateTime createdAt;

  const ExperimentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.tags,
    required this.difficulty,
    this.concepts,
    this.imagePath,
    required this.githubLink,
    required this.notebookName,
    required this.createdAt,
  });

  // Factory constructor for easy JSON parsing in future
  factory ExperimentModel.fromJson(Map<String, dynamic> json) {
    return ExperimentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      tags: List<String>.from(json['tags'] as List),
      difficulty: json['difficulty'] as String,
      concepts: json['concepts'] as String?,
      imagePath: json['imagePath'] as String?,
      githubLink: json['githubLink'] as String,
      notebookName: json['notebookName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'tags': tags,
      'difficulty': difficulty,
      'concepts': concepts,
      'imagePath': imagePath,
      'githubLink': githubLink,
      'notebookName': notebookName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
