import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../models/shopping_item.dart';
import '../models/recipe.dart';

class ShoppingListController extends StateNotifier<Map<String, ShoppingList>> {
  ShoppingListController() : super({});

  // Generate shopping list from recipes
  ShoppingList generateFromRecipes(String tripId, List<Recipe> recipes) {
    // Don't regenerate if already exists
    if (state[tripId] != null && state[tripId]!.items.isNotEmpty) {
      return state[tripId]!;
    }
    
    final Map<String, ShoppingItem> aggregatedItems = {};
    
    for (final recipe in recipes) {
      for (final ingredient in recipe.ingredients) {
        final key = '${ingredient.itemName}_${ingredient.unit}';
        
        if (aggregatedItems.containsKey(key)) {
          // Merge quantities for same ingredient
          final existing = aggregatedItems[key]!;
          aggregatedItems[key] = existing.copyWith(
            quantity: existing.quantity + ingredient.qty,
          );
        } else {
          // Create new shopping item
          aggregatedItems[key] = ShoppingItem(
            id: '${tripId}_${ingredient.itemName}_${DateTime.now().millisecondsSinceEpoch}',
            name: ingredient.itemName,
            category: ingredient.category,
            quantity: ingredient.qty,
            unit: ingredient.unit,
            isCompleted: false,
            createdAt: DateTime.now(),
          );
        }
      }
    }
    
    final shoppingList = ShoppingList(
      tripId: tripId,
      items: aggregatedItems.values.toList(),
      lastUpdated: DateTime.now(),
    );
    
    state = {...state, tripId: shoppingList};
    return shoppingList;
  }

  // Add a new shopping item
  void addItem(String tripId, ShoppingItem item) {
    final currentList = state[tripId];
    if (currentList != null) {
      final updatedItems = [...currentList.items, item];
      state = {
        ...state,
        tripId: currentList.copyWith(
          items: updatedItems,
          lastUpdated: DateTime.now(),
        ),
      };
    }
  }

  // Remove a shopping item
  void removeItem(String tripId, String itemId) {
    final currentList = state[tripId];
    if (currentList != null) {
      final updatedItems = currentList.items.where((item) => item.id != itemId).toList();
      state = {
        ...state,
        tripId: currentList.copyWith(
          items: updatedItems,
          lastUpdated: DateTime.now(),
        ),
      };
    }
  }

  // Toggle completion status of an item
  void toggleItemCompletion(String tripId, String itemId, String? assignedTo) {
    final currentList = state[tripId];
    if (currentList != null) {
      final updatedItems = currentList.items.map((item) {
        if (item.id == itemId) {
          final newCompleted = !item.isCompleted;
          return item.copyWith(
            isCompleted: newCompleted,
            completedAt: newCompleted ? DateTime.now() : null,
            // Automatically assign to user when completing, or remove assignment when uncompleting
            assignedTo: assignedTo,
          );
        }
        return item;
      }).toList();
      
      state = {
        ...state,
        tripId: currentList.copyWith(
          items: updatedItems,
          lastUpdated: DateTime.now(),
        ),
      };
    }
  }

  // Assign item to a person
  void assignItem(String tripId, String itemId, String? assignedTo) {
    final currentList = state[tripId];
    if (currentList != null) {
      final updatedItems = currentList.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(
            assignedTo: assignedTo,
            // If removing assignment, also mark as not completed
            isCompleted: assignedTo != null ? item.isCompleted : false,
            completedAt: assignedTo != null ? item.completedAt : null,
          );
        }
        return item;
      }).toList();
      
      state = {
        ...state,
        tripId: currentList.copyWith(
          items: updatedItems,
          lastUpdated: DateTime.now(),
        ),
      };
    }
  }

  // Update item notes
  void updateItemNotes(String tripId, String itemId, String? notes) {
    final currentList = state[tripId];
    if (currentList != null) {
      final updatedItems = currentList.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(notes: notes);
        }
        return item;
      }).toList();
      
      state = {
        ...state,
        tripId: currentList.copyWith(
          items: updatedItems,
          lastUpdated: DateTime.now(),
        ),
      };
    }
  }

  // Get shopping list for a trip
  ShoppingList? getShoppingList(String tripId) {
    return state[tripId];
  }

  // Get items grouped by category
  Map<String, List<ShoppingItem>> getItemsByCategory(String tripId) {
    final list = state[tripId];
    if (list == null) return {};
    
    return groupBy(list.items, (item) => item.category);
  }

  // Get completion statistics
  Map<String, dynamic> getCompletionStats(String tripId) {
    final list = state[tripId];
    if (list == null) {
      return {
        'total': 0,
        'completed': 0,
        'pending': 0,
        'percentage': 0.0,
      };
    }
    
    final total = list.items.length;
    final completed = list.items.where((item) => item.isCompleted).length;
    final pending = total - completed;
    final percentage = total > 0 ? (completed / total) * 100 : 0.0;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'percentage': percentage,
    };
  }
}

final shoppingListControllerProvider = StateNotifierProvider<ShoppingListController, Map<String, ShoppingList>>((ref) {
  return ShoppingListController();
});

// Provider for a specific trip's shopping list
final tripShoppingListProvider = Provider.family<ShoppingList?, String>((ref, tripId) {
  final controller = ref.watch(shoppingListControllerProvider);
  return controller[tripId];
});

// Provider for shopping list items grouped by category
final shoppingListByCategoryProvider = Provider.family<Map<String, List<ShoppingItem>>, String>((ref, tripId) {
  final state = ref.watch(shoppingListControllerProvider);
  final list = state[tripId];
  if (list == null) return {};
  
  return groupBy(list.items, (item) => item.category);
});

// Provider for completion statistics
final shoppingListStatsProvider = Provider.family<Map<String, dynamic>, String>((ref, tripId) {
  final state = ref.watch(shoppingListControllerProvider);
  final list = state[tripId];
  if (list == null) {
    return {
      'total': 0,
      'completed': 0,
      'pending': 0,
      'percentage': 0.0,
    };
  }
  
  final total = list.items.length;
  final completed = list.items.where((item) => item.isCompleted).length;
  final pending = total - completed;
  final percentage = total > 0 ? (completed / total) * 100 : 0.0;
  
  return {
    'total': total,
    'completed': completed,
    'pending': pending,
    'percentage': percentage,
  };
});
