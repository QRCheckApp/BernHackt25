import '../models/item.dart';

final List<Item> seedItems = [
  const Item(
    id: 'milk',
    name: 'Milch',
    category: 'dairy',
    baseUnit: 'ml',
    packSizeBase: 1000, // 1l
  ),
  const Item(
    id: 'pasta',
    name: 'Pasta',
    category: 'pasta',
    baseUnit: 'g',
    packSizeBase: 500, // 500g
  ),
  const Item(
    id: 'passata',
    name: 'Passata',
    category: 'canned',
    baseUnit: 'ml',
    packSizeBase: 700, // 700ml
  ),
  const Item(
    id: 'eggs',
    name: 'Eier',
    category: 'dairy',
    baseUnit: 'pcs',
    packSizeBase: 10, // 10 pieces
  ),
  const Item(
    id: 'cheese',
    name: 'Käse',
    category: 'dairy',
    baseUnit: 'g',
    packSizeBase: 200, // 200g
  ),
  const Item(
    id: 'bread',
    name: 'Brot',
    category: 'bakery',
    baseUnit: 'g',
    packSizeBase: 800, // 800g
  ),
  const Item(
    id: 'coffee_caps',
    name: 'Kaffeekapseln',
    category: 'beverage',
    baseUnit: 'pcs',
    packSizeBase: 10, // 10 pieces
  ),
  const Item(
    id: 'beer',
    name: 'Bier',
    category: 'beverage',
    baseUnit: 'ml',
    packSizeBase: 1980, // 6x330ml
  ),
  const Item(
    id: 'wine',
    name: 'Wein',
    category: 'beverage',
    baseUnit: 'ml',
    packSizeBase: 750, // 0.75l
  ),
  const Item(
    id: 'almond_milk',
    name: 'Mandelmilch',
    category: 'beverage',
    baseUnit: 'ml',
    packSizeBase: 1000, // 1l
  ),
];
