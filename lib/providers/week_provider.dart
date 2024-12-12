import 'package:flutter/material.dart';

class WeekProvider extends ChangeNotifier {
  DateTime _selectedWeek = DateTime.now();

  DateTime get selectedWeek => _selectedWeek;

  // Get the start of the current week (Monday)
  DateTime get weekStart {
    final now = _selectedWeek;
    return now.subtract(Duration(days: now.weekday - 1));
  }

  // Get the end of the current week (Sunday)
  DateTime get weekEnd {
    return weekStart.add(const Duration(days: 6));
  }

  void nextWeek() {
    _selectedWeek = _selectedWeek.add(const Duration(days: 7));
    notifyListeners();
  }

  void previousWeek() {
    _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
    notifyListeners();
  }
} 