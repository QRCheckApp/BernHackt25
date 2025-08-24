import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../../models/recipe.dart';

class AddMealDialog extends ConsumerStatefulWidget {
  const AddMealDialog({super.key});

  @override
  ConsumerState<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends ConsumerState<AddMealDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _servingsController = TextEditingController(text: '4');
  final _prepTimeController = TextEditingController(text: '15');
  final _cookTimeController = TextEditingController(text: '30');
  
  String _selectedDiet = 'omnivore';
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  final List<String> _availableDiets = [
    'omnivore',
    'vegetarisch',
    'vegan',
    'pescetarisch',
    'glutenfrei',
  ];

  final List<String> _availableTags = [
    'schnell',
    'einfach',
    'gesund',
    'italienisch',
    'asiatisch',
    'mexikanisch',
    'deutsch',
    'vegetarisch',
    'vegan',
    'glutenfrei',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _servingsController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Neue Mahlzeit hinzufügen'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  hintText: 'z. B. Spaghetti Pomodoro',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Bitte gib einen Titel ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _servingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Portionen',
                      ),
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) {
                          return 'Zahl eingeben';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDiet,
                      decoration: const InputDecoration(
                        labelText: 'Ernährung',
                      ),
                      items: _availableDiets.map((diet) {
                        return DropdownMenuItem(
                          value: diet,
                          child: Text(diet),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDiet = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prepTimeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Vorbereitung (min)',
                      ),
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) {
                          return 'Zahl eingeben';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cookTimeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Kochzeit (min)',
                      ),
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) {
                          return 'Zahl eingeben';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Tags section
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTags.map((tag) {
                  final isSelected = _tags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _tags.add(tag);
                        } else {
                          _tags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _saveMeal,
          child: const Text('Speichern'),
        ),
      ],
    );
  }

  void _saveMeal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final random = Random();
    final meal = Recipe(
      id: 'manual_${random.nextInt(99999)}',
      title: _titleController.text.trim(),
      servingsBase: int.parse(_servingsController.text),
      tags: _tags,
      satisfies: [_selectedDiet],
      excludesAllergens: const [],
      applianceRequirements: const ['stove'],
      ingredients: [
        RecipeIngredient(
          itemName: 'Zutat 1',
          qty: 100,
          unit: 'g',
          category: 'misc',
        ),
        RecipeIngredient(
          itemName: 'Zutat 2',
          qty: 200,
          unit: 'ml',
          category: 'misc',
        ),
      ],
      steps: const [
        'Schritt 1: Vorbereitung',
        'Schritt 2: Kochen',
        'Schritt 3: Servieren',
      ],
      estPrepMin: int.parse(_prepTimeController.text),
      estCookMin: int.parse(_cookTimeController.text),
    );

    Navigator.of(context).pop(meal);
  }
}
