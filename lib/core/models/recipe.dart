import 'dart:ffi';

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;
  final double score;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    required this.score
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['name'] as String,
      description: json['description'] as String,
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
      imageUrl: json['image'] as String,
      score: json['score'] as double
    );
  }
}