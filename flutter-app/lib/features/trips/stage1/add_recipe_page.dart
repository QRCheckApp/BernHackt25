import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRecipePage extends ConsumerStatefulWidget {
  const AddRecipePage({super.key});

  @override
  ConsumerState<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends ConsumerState<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _servingsCtrl = TextEditingController(text: '4');
  final _ingredientNameCtrl = TextEditingController();
  final _ingredientQtyCtrl = TextEditingController(text: '500');
  final _ingredientUnitCtrl = TextEditingController(text: 'g');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _servingsCtrl.dispose();
    _ingredientNameCtrl.dispose();
    _ingredientQtyCtrl.dispose();
    _ingredientUnitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rezept manuell hinzufügen')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  hintText: 'z. B. Spaghetti Pomodoro',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _servingsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Portionen',
                ),
                validator: (v) => (v == null || int.tryParse(v) == null) ? 'Zahl eingeben' : null,
              ),
              const SizedBox(height: 24),
              const Text('Zutat (Mock, eine reicht für Demo)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ingredientNameCtrl,
                decoration: const InputDecoration(labelText: 'Zutat', hintText: 'z. B. Pasta'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ingredientQtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Menge'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _ingredientUnitCtrl,
                      decoration: const InputDecoration(labelText: 'Einheit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  // Mock only: just pop with a result map; Stage1View will handle insertion into its local list.
                  Navigator.of(context).pop({
                    'title': _titleCtrl.text.trim(),
                    'servings': int.parse(_servingsCtrl.text),
                    'ingredient': {
                      'name': _ingredientNameCtrl.text.trim().isEmpty ? 'Pasta' : _ingredientNameCtrl.text.trim(),
                      'qty': double.tryParse(_ingredientQtyCtrl.text) ?? 500,
                      'unit': _ingredientUnitCtrl.text.trim().isEmpty ? 'g' : _ingredientUnitCtrl.text.trim(),
                    }
                  });
                },
                child: const Text('Speichern (Mock)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
