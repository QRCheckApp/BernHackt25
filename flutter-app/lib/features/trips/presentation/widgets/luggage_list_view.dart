import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_state/providers.dart';
import '../../../app_state/luggage_list_controller.dart';
import '../../../app_state/shopping_list_controller.dart';
import '../../../models/luggage_item.dart';
import '../../../data/seed_luggage_items.dart';

class LuggageListView extends ConsumerStatefulWidget {
  final String tripId;
  
  const LuggageListView({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<LuggageListView> createState() => _LuggageListViewState();
}

class _LuggageListViewState extends ConsumerState<LuggageListView> {
  bool _showPacked = true;



  @override
  Widget build(BuildContext context) {
    final luggageList = ref.watch(tripLuggageListProvider(widget.tripId));
    final trip = ref.watch(tripDetailsProvider(widget.tripId));
    
    if (trip == null) {
      return const Center(
        child: Text('Trip nicht gefunden'),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildToggle(context),
            Expanded(
              child: luggageList == null || luggageList.items.isEmpty
                  ? _buildEmptyState(context)
                  : _buildLuggageList(context, luggageList),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_item',
        onPressed: () => _showAddItemBottomSheet(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Hinzufügen'),
      ),
    );
  }

  Widget _buildToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _showPacked,
            onChanged: (value) {
              setState(() {
                _showPacked = value ?? true;
              });
            },
          ),
          const Text('Gepackte anzeigen'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.luggage_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Packliste vorhanden',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Die Packliste wird automatisch aus den abgehakten Einkaufsitems erstellt.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuggageList(BuildContext context, LuggageList luggageList) {
    // Filter items based on packed status only
    final filteredItems = luggageList.items.where((item) {
      if (!_showPacked && item.isPacked) {
        return false;
      }
      return true;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return _buildLuggageItem(context, filteredItems[index]);
      },
    );
  }



  Widget _buildLuggageItem(BuildContext context, LuggageItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: item.isPacked,
          onChanged: (value) {
            ref.read(luggageListControllerProvider.notifier).togglePackedStatus(
              widget.tripId,
              item.id,
              null, // No assignment needed
            );
          },
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isPacked ? TextDecoration.lineThrough : null,
            color: item.isPacked 
                ? Theme.of(context).colorScheme.onSurfaceVariant 
                : null,
          ),
        ),
        subtitle: Text(
          '${item.quantity} ${item.unit}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }



  void _showAddItemBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddLuggageItemBottomSheet(tripId: widget.tripId),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class AddLuggageItemBottomSheet extends ConsumerStatefulWidget {
  final String tripId;
  
  const AddLuggageItemBottomSheet({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<AddLuggageItemBottomSheet> createState() => _AddLuggageItemBottomSheetState();
}

class _AddLuggageItemBottomSheetState extends ConsumerState<AddLuggageItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedCategory = 'Sonstiges';

  final List<String> _categories = [
    'Gemüse',
    'Obst',
    'Fleisch',
    'Milchprodukte',
    'Getreide',
    'Gewürze',
    'Sonstiges',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              'Gegenstand hinzufügen',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Quick fill chips
            Text(
              'Schnell hinzufügen:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickFillChips(),
            const SizedBox(height: 24),
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie einen Namen ein';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Menge',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie eine Menge ein';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Bitte geben Sie eine gültige Zahl ein';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _unitController,
                          decoration: const InputDecoration(
                            labelText: 'Einheit',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie eine Einheit ein';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategorie',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notizen (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Abbrechen'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addItem,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Hinzufügen'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFillChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: predefinedLuggageItems.map((predefinedItem) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () => _fillFormWithPredefinedItem(predefinedItem),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(predefinedItem.name),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _fillFormWithPredefinedItem(PredefinedLuggageItem predefinedItem) {
    setState(() {
      _nameController.text = predefinedItem.name;
      _quantityController.text = predefinedItem.quantity.toString();
      _unitController.text = predefinedItem.unit;
      _selectedCategory = predefinedItem.category;
      if (predefinedItem.notes != null) {
        _notesController.text = predefinedItem.notes!;
      }
    });
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      final item = LuggageItem(
        id: 'luggage_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        category: _selectedCategory,
        quantity: double.parse(_quantityController.text),
        unit: _unitController.text,
        isPacked: false,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        createdAt: DateTime.now(),
      );
      
      ref.read(luggageListControllerProvider.notifier).addItem(widget.tripId, item);
      Navigator.of(context).pop();
    }
  }
}
