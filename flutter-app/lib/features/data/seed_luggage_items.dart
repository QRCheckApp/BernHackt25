import '../models/luggage_item.dart';

class PredefinedLuggageItem {
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final String? notes;

  const PredefinedLuggageItem({
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    this.notes,
  });

  LuggageItem toLuggageItem() {
    return LuggageItem(
      id: 'luggage_${DateTime.now().millisecondsSinceEpoch}_${name.toLowerCase().replaceAll(' ', '_')}',
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      isPacked: false,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }
}

final List<PredefinedLuggageItem> predefinedLuggageItems = [
  const PredefinedLuggageItem(
    name: 'Kulturtasche',
    category: 'Sonstiges',
    quantity: 1,
    unit: 'Stück',
  ),
  const PredefinedLuggageItem(
    name: 'T-Shirt',
    category: 'Sonstiges',
    quantity: 3,
    unit: 'Stück',
  ),
  const PredefinedLuggageItem(
    name: 'Unterhose',
    category: 'Sonstiges',
    quantity: 5,
    unit: 'Stück',
  ),
  const PredefinedLuggageItem(
    name: 'Socken',
    category: 'Sonstiges',
    quantity: 5,
    unit: 'Paar',
  ),
  const PredefinedLuggageItem(
    name: 'Ladekabel',
    category: 'Sonstiges',
    quantity: 1,
    unit: 'Stück',
  ),
  const PredefinedLuggageItem(
    name: 'Zahnbürste',
    category: 'Sonstiges',
    quantity: 1,
    unit: 'Stück',
  ),
  const PredefinedLuggageItem(
    name: 'Handtuch',
    category: 'Sonstiges',
    quantity: 2,
    unit: 'Stück',
  ),
  const PredefinedLuggageItem(
    name: 'Buch',
    category: 'Sonstiges',
    quantity: 1,
    unit: 'Stück',
  ),
  const PredefinedLuggageItem(
    name: 'Sonnenbrille',
    category: 'Sonstiges',
    quantity: 1,
    unit: 'Stück',
  ),
  const PredefinedLuggageItem(
    name: 'Regenschirm',
    category: 'Sonstiges',
    quantity: 1,
    unit: 'Stück',
  ),
];
