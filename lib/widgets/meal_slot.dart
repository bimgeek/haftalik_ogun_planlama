import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealSlot extends StatelessWidget {
  final String mealType;
  final Meal? meal;
  final VoidCallback? onTap;

  const MealSlot({
    super.key,
    required this.mealType,
    this.meal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: meal?.imageUrl != null
                    ? Image.network(
                        meal!.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 32,
                        ),
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  meal?.name ?? mealType,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 