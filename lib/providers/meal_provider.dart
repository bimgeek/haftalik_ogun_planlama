import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealProvider extends ChangeNotifier {
  final Map<DateTime, List<Meal>> _meals = {};

  List<Meal> getMealsForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _meals[key] ?? [];
  }

  void addMeal(DateTime date, Meal meal) {
    final key = DateTime(date.year, date.month, date.day);
    final meals = _meals[key] ?? [];
    meals.add(meal);
    _meals[key] = meals;
    notifyListeners();
  }

  void updateMeal(DateTime date, Meal updatedMeal) {
    final key = DateTime(date.year, date.month, date.day);
    final meals = _meals[key] ?? [];
    final index = meals.indexWhere((meal) => meal.id == updatedMeal.id);
    if (index != -1) {
      meals[index] = updatedMeal;
      _meals[key] = meals;
      notifyListeners();
    }
  }

  void deleteMeal(DateTime date, String mealId) {
    final key = DateTime(date.year, date.month, date.day);
    final meals = _meals[key] ?? [];
    meals.removeWhere((meal) => meal.id == mealId);
    _meals[key] = meals;
    notifyListeners();
  }
} 