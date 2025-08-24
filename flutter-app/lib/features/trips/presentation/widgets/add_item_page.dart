import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_state/shopping_list_controller.dart';
import '../../../models/shopping_item.dart';

class AddItemPage extends ConsumerStatefulWidget {
  final String tripId;
  
  const AddItemPage({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends ConsumerState<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedCategory = 'produce';
  String _selectedUnit = 'pcs';

  final List<String> _categories = [
    'produce',
    'dairy',
    'meat',
    'grains',
    'spices',
    'canned',
    'beverages',
    'oil',
    'pasta',
    'other',
  ];

  final List<String> _units = [
    'pcs',
    'g',
    'kg',
    'ml',
    'l',
    'tbsp',
    'tsp',
    'cup',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel hinzufügen'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildNameField(context),
                const SizedBox(height: 16),
                _buildQuantityAndUnitRow(context),
                const SizedBox(height: 16),
                _buildCategoryField(context),
                const SizedBox(height: 16),
                _buildNotesField(context),
                const SizedBox(height: 32),
                _buildAddButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add_shopping_cart,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Neuen Artikel hinzufügen',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Füge einen benutzerdefinierten Artikel zur Einkaufsliste hinzu',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Artikelname *',
        hintText: 'z.B. Milch, Brot, Tomaten...',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.shopping_basket),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Bitte gib einen Artikelnamen ein';
        }
        return null;
      },
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildQuantityAndUnitRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Menge *',
              hintText: '1',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.straighten),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bitte gib eine Menge ein';
              }
              final quantity = double.tryParse(value);
              if (quantity == null || quantity <= 0) {
                return 'Menge muss eine positive Zahl sein';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            value: _selectedUnit,
            decoration: const InputDecoration(
              labelText: 'Einheit',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.straighten),
            ),
            items: _units.map((unit) => DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedUnit = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Kategorie',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      items: _categories.map((category) => DropdownMenuItem<String>(
        value: category,
        child: Row(
          children: [
            Icon(_getCategoryIcon(category), size: 16),
            const SizedBox(width: 8),
            Text(_getCategoryDisplayName(category)),
          ],
        ),
      )).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notizen (optional)',
        hintText: 'Zusätzliche Informationen...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _addItem,
        icon: const Icon(Icons.add),
        label: const Text('Artikel hinzufügen'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'produce':
        return Icons.eco;
      case 'dairy':
        return Icons.local_drink;
      case 'meat':
        return Icons.restaurant;
      case 'grains':
        return Icons.grain;
      case 'spices':
        return Icons.spa;
      case 'canned':
        return Icons.inventory;
      case 'beverages':
        return Icons.local_bar;
      case 'oil':
        return Icons.water_drop;
      case 'pasta':
        return Icons.restaurant_menu;
      default:
        return Icons.shopping_basket;
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'produce':
        return 'Obst & Gemüse';
      case 'dairy':
        return 'Milchprodukte';
      case 'meat':
        return 'Fleisch & Fisch';
      case 'grains':
        return 'Getreide';
      case 'spices':
        return 'Gewürze';
      case 'canned':
        return 'Konserven';
      case 'beverages':
        return 'Getränke';
      case 'oil':
        return 'Öle & Fette';
      case 'pasta':
        return 'Pasta & Nudeln';
      default:
        return 'Sonstiges';
    }
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      final quantity = double.parse(_quantityController.text);
      
      final newItem = ShoppingItem(
        id: '${widget.tripId}_manual_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        category: _selectedCategory,
        quantity: quantity,
        unit: _selectedUnit,
        isCompleted: false,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: DateTime.now(),
      );
      
      ref.read(shoppingListControllerProvider.notifier).addItem(widget.tripId, newItem);
      
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newItem.name} zur Einkaufsliste hinzugefügt'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
