import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../models/luggage_item.dart';
import '../models/shopping_item.dart';
import 'shopping_list_controller.dart';

class LuggageListController extends StateNotifier<Map<String, LuggageList>> {
  LuggageListController() : super({});

  // Generate luggage list from completed shopping items
  void generateFromCompletedShoppingItems(String tripId, List<ShoppingItem> shoppingItems) {
    final completedItems = shoppingItems.where((item) => item.isCompleted).toList();
    final currentList = state[tripId];
    
    // Create a map of existing luggage items by their original shopping item ID
    final existingItemsMap = <String, LuggageItem>{};
    if (currentList != null) {
      for (final item in currentList.items) {
        if (item.originalShoppingItemId != null) {
          existingItemsMap[item.originalShoppingItemId!] = item;
        }
      }
    }
    
    final luggageItems = completedItems.map((shoppingItem) {
      // Check if we already have this item in the luggage list
      if (existingItemsMap.containsKey(shoppingItem.id)) {
        // Keep the existing item (preserve packed status, etc.)
        return existingItemsMap[shoppingItem.id]!;
      } else {
        // Create new luggage item
        return LuggageItem(
          id: 'luggage_${shoppingItem.id}',
          name: shoppingItem.name,
          category: shoppingItem.category,
          quantity: shoppingItem.quantity,
          unit: shoppingItem.unit,
          isPacked: false,
          assignedTo: shoppingItem.assignedTo,
          notes: shoppingItem.notes,
          createdAt: DateTime.now(),
          originalShoppingItemId: shoppingItem.id,
        );
      }
    }).toList();
    
    // Add any manually added items that don't have an originalShoppingItemId
    if (currentList != null) {
      final manualItems = currentList.items.where((item) => item.originalShoppingItemId == null).toList();
      luggageItems.addAll(manualItems);
    }
    
    final luggageList = LuggageList(
      tripId: tripId,
      items: luggageItems,
      lastUpdated: DateTime.now(),
    );
    
    state = {...state, tripId: luggageList};
  }

  // Add a new luggage item
  void addItem(String tripId, LuggageItem item) {
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
    } else {
      // Create new luggage list if it doesn't exist
      final newList = LuggageList(
        tripId: tripId,
        items: [item],
        lastUpdated: DateTime.now(),
      );
      state = {...state, tripId: newList};
    }
  }

  // Remove a luggage item
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

  // Toggle packed status of an item
  void togglePackedStatus(String tripId, String itemId, String? assignedTo) {
    final currentList = state[tripId];
    if (currentList != null) {
      final updatedItems = currentList.items.map((item) {
        if (item.id == itemId) {
          final newPacked = !item.isPacked;
          return item.copyWith(
            isPacked: newPacked,
            packedAt: newPacked ? DateTime.now() : null,
            // Automatically assign to user when packing, or remove assignment when unpacking
            assignedTo: newPacked ? assignedTo : null,
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
            // If removing assignment, also mark as not packed
            isPacked: assignedTo != null ? item.isPacked : false,
            packedAt: assignedTo != null ? item.packedAt : null,
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

  // Get luggage list for a trip
  LuggageList? getLuggageList(String tripId) {
    return state[tripId];
  }

  // Get items grouped by category
  Map<String, List<LuggageItem>> getItemsByCategory(String tripId) {
    final list = state[tripId];
    if (list == null) return {};
    
    return groupBy(list.items, (item) => item.category);
  }

  // Get packing statistics
  Map<String, dynamic> getPackingStats(String tripId) {
    final list = state[tripId];
    if (list == null) {
      return {
        'total': 0,
        'packed': 0,
        'pending': 0,
        'percentage': 0.0,
      };
    }
    
    final total = list.items.length;
    final packed = list.items.where((item) => item.isPacked).length;
    final pending = total - packed;
    final percentage = total > 0 ? (packed / total) * 100 : 0.0;
    
    return {
      'total': total,
      'packed': packed,
      'pending': pending,
      'percentage': percentage,
    };
  }
}

final luggageListControllerProvider = StateNotifierProvider<LuggageListController, Map<String, LuggageList>>((ref) {
  return LuggageListController();
});

// Provider for a specific trip's luggage list that automatically updates from shopping list
final tripLuggageListProvider = Provider.family<LuggageList?, String>((ref, tripId) {
  // Watch the shopping list to trigger updates
  final shoppingList = ref.watch(tripShoppingListProvider(tripId));
  final controller = ref.watch(luggageListControllerProvider);
  
  // If shopping list exists and has completed items, ensure luggage list is generated
  if (shoppingList != null && shoppingList.items.isNotEmpty) {
    final completedItems = shoppingList.items.where((item) => item.isCompleted).toList();
    final currentLuggageList = controller[tripId];
    
    // If no luggage list exists or if the number of completed items changed, regenerate
    if (currentLuggageList == null || 
        currentLuggageList.items.length != completedItems.length) {
      // Use a post-frame callback to avoid build-time state changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(luggageListControllerProvider.notifier).generateFromCompletedShoppingItems(
          tripId, 
          shoppingList.items,
        );
      });
    }
  }
  
  return controller[tripId];
});

// Provider for luggage list items grouped by category
final luggageListByCategoryProvider = Provider.family<Map<String, List<LuggageItem>>, String>((ref, tripId) {
  final state = ref.watch(luggageListControllerProvider);
  final list = state[tripId];
  if (list == null) return {};
  
  return groupBy(list.items, (item) => item.category);
});

// Provider for packing statistics
final luggageListStatsProvider = Provider.family<Map<String, dynamic>, String>((ref, tripId) {
  final state = ref.watch(luggageListControllerProvider);
  final list = state[tripId];
  if (list == null) {
    return {
      'total': 0,
      'packed': 0,
      'pending': 0,
      'percentage': 0.0,
    };
  }
  
  final total = list.items.length;
  final packed = list.items.where((item) => item.isPacked).length;
  final pending = total - packed;
  final percentage = total > 0 ? (packed / total) * 100 : 0.0;
  
  return {
    'total': total,
    'packed': packed,
    'pending': pending,
    'percentage': percentage,
  };
});
