import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../screens/meal_detail_screen.dart';

class DayDetailScreen extends StatelessWidget {
  final DateTime date;

  const DayDetailScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  List<Meal> _getMealsByType(BuildContext context, String type) {
    final mealProvider = Provider.of<MealProvider>(context);
    return mealProvider.getMealsForDate(date).where((meal) => meal.mealType == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final meals = mealProvider.getMealsForDate(date);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${date.month}/${date.day}/${date.year}',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMealSection(context, 'Breakfast'),
          _buildMealSection(context, 'Lunch'),
          _buildMealSection(context, 'Snacks'),
          _buildMealSection(context, 'Dinner'),
        ],
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, String mealType) {
    final theme = Theme.of(context);
    final mealsForType = _getMealsByType(context, mealType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealType,
                style: theme.textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _navigateToMealDetail(context, mealType);
                },
              ),
            ],
          ),
        ),
        if (mealsForType.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No meals planned for $mealType',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          )
        else
          ...mealsForType.map((meal) => _buildMealCard(context, meal)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, Meal meal) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to meal detail/edit screen
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meal.imageUrl != null)
              Image.network(
                meal.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          meal.name,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < meal.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (meal.notes != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      meal.notes!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMealDetail(BuildContext context, String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(
          date: date,
          mealType: mealType,
        ),
      ),
    );
  }
} 