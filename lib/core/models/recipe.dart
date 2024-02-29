class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;
  final double rating;
  final int ratingCount;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    String id = json['id'] != null ? json['id'] as String : DateTime.now().millisecondsSinceEpoch.toString();
    String description = json['description'] != null ? json['description'] as String : "empty description";

    return Recipe(
      id: id,
      title: json['title'] as String,
      description: description,
      ingredients: List<String>.from(json['ingredient']),
      steps: List<String>.from(json['instruction']),
      imageUrl: json['image'] as String,
      rating: (json['rating'] as num).toDouble(), 
      ratingCount: json['rating-count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'image': imageUrl,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }
}
