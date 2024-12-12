import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';

class MealDetailScreen extends StatefulWidget {
  final DateTime date;
  final Meal? meal;
  final String mealType;

  const MealDetailScreen({
    Key? key,
    required this.date,
    this.meal,
    required this.mealType,
  }) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;
  late TextEditingController _notesController;
  late List<String> _ingredients;
  late List<String> _instructions;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.meal?.name ?? '');
    _imageUrlController = TextEditingController(text: widget.meal?.imageUrl ?? '');
    _notesController = TextEditingController(text: widget.meal?.notes ?? '');
    _ingredients = widget.meal?.ingredients ?? [];
    _instructions = widget.meal?.instructions ?? [];
    _rating = widget.meal?.rating ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveMeal() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a meal name')),
      );
      return;
    }

    final meal = Meal(
      id: widget.meal?.id ?? DateTime.now().toString(),
      name: _nameController.text,
      imageUrl: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      ingredients: _ingredients,
      instructions: _instructions,
      rating: _rating,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      mealType: widget.mealType,
    );

    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    if (widget.meal == null) {
      mealProvider.addMeal(widget.date, meal);
    } else {
      mealProvider.updateMeal(widget.date, meal);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal == null ? 'Add Meal' : 'Edit Meal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMeal,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Meal Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          _buildIngredientsList(),
          const SizedBox(height: 16),
          _buildInstructionsList(),
          const SizedBox(height: 16),
          _buildRatingSelector(),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Ingredients'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _ingredients.add('');
                });
              },
            ),
          ),
          ..._ingredients.asMap().entries.map((entry) {
            return ListTile(
              leading: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _ingredients.removeAt(entry.key);
                  });
                },
              ),
              title: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter ingredient',
                ),
                onChanged: (value) {
                  _ingredients[entry.key] = value;
                },
                controller: TextEditingController(text: entry.value),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInstructionsList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Instructions'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _instructions.add('');
                });
              },
            ),
          ),
          ..._instructions.asMap().entries.map((entry) {
            return ListTile(
              leading: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _instructions.removeAt(entry.key);
                  });
                },
              ),
              title: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter instruction step',
                ),
                onChanged: (value) {
                  _instructions[entry.key] = value;
                },
                controller: TextEditingController(text: entry.value),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRatingSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
          },
        );
      }),
    );
  }
} 