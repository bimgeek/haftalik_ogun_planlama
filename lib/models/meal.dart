class Meal {
  final String id;
  final String name;
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final double rating;
  final String? notes;
  final String mealType; // 'Breakfast', 'Lunch', 'Snacks', 'Dinner'

  Meal({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.rating = 0.0,
    this.notes,
    required this.mealType,
  });
} 