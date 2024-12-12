import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../screens/meal_detail_screen.dart';
import '../widgets/meal_slot.dart';

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
          DateFormat('EEEE, MMM d').format(date),
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMealTypeSection(context, 'Breakfast'),
          const SizedBox(height: 24),
          _buildMealTypeSection(context, 'Lunch'),
          const SizedBox(height: 24),
          _buildMealTypeSection(context, 'Snacks'),
          const SizedBox(height: 24),
          _buildMealTypeSection(context, 'Dinner'),
        ],
      ),
    );
  }

  Widget _buildMealTypeSection(BuildContext context, String mealType) {
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
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            children: [
              if (mealsForType.isEmpty)
                SizedBox(
                  width: 160,
                  child: MealSlot(
                    mealType: mealType,
                    meal: null,
                    onTap: () => _navigateToMealDetail(context, mealType),
                  ),
                )
              else
                ...mealsForType.map((meal) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 160,
                    child: MealSlot(
                      mealType: mealType,
                      meal: meal,
                      onTap: () => _navigateToMealDetail(
                        context,
                        mealType,
                        meal: meal,
                      ),
                    ),
                  ),
                )).toList(),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToMealDetail(BuildContext context, String mealType, {Meal? meal}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(
          date: date,
          mealType: mealType,
          meal: meal,
        ),
      ),
    );
  }
} 