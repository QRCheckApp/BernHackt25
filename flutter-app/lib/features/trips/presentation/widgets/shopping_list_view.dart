import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_state/providers.dart';
import '../../../app_state/shopping_list_controller.dart';
import '../../../models/shopping_item.dart';
import '../../../data/seed_recipes.dart';
import 'add_item_page.dart';

class ShoppingListView extends ConsumerStatefulWidget {
  final String tripId;
  
  const ShoppingListView({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends ConsumerState<ShoppingListView> {
  bool _showCompleted = true;
  String? _selectedCategory;
  String? _selectedAssignee;

  @override
  void initState() {
    super.initState();
    // Automatically generate shopping list when view is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureShoppingListExists();
    });
  }

  void _ensureShoppingListExists() {
    final shoppingList = ref.read(tripShoppingListProvider(widget.tripId));
    if (shoppingList == null || shoppingList.items.isEmpty) {
      // Use the same recipes as Stage2RecipesView
      final recipes = seedRecipes;
      if (recipes.isNotEmpty) {
        ref.read(shoppingListControllerProvider.notifier).generateFromRecipes(widget.tripId, recipes);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shoppingList = ref.watch(tripShoppingListProvider(widget.tripId));
    final stats = ref.watch(shoppingListStatsProvider(widget.tripId));
    final trip = ref.watch(tripDetailsProvider(widget.tripId));
    
    if (trip == null) {
      return const Center(
        child: Text('Trip nicht gefunden'),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, stats),
              _buildFilters(context),
              shoppingList == null || shoppingList.items.isEmpty
                  ? _buildEmptyState(context)
                  : _buildShoppingList(context, shoppingList),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_item',
        onPressed: () => _showAddItemPage(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Hinzufügen'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Einkaufsliste',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Verwalte alle benötigten Zutaten',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressCard(context, stats),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, Map<String, dynamic> stats) {
    final percentage = stats['percentage'] as double;
    final completed = stats['completed'] as int;
    final total = stats['total'] as int;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fortschritt',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${completed}/${total}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: total > 0 ? percentage / 100 : 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}% erledigt',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final categories = ref.watch(shoppingListByCategoryProvider(widget.tripId)).keys.toList();
    final trip = ref.watch(tripDetailsProvider(widget.tripId));
    final members = trip?.members.map((m) => m.name).toList() ?? [];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategorie',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Alle Kategorien'),
                    ),
                    ...categories.map((category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedAssignee,
                  decoration: const InputDecoration(
                    labelText: 'Zugewiesen',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Alle'),
                    ),
                    ...members.map((member) => DropdownMenuItem<String>(
                      value: member,
                      child: Text(member),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedAssignee = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _showCompleted,
                onChanged: (value) {
                  setState(() {
                    _showCompleted = value ?? true;
                  });
                },
              ),
              const Text('Erledigte anzeigen'),
            ],
          ),
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
              Icons.shopping_cart_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Einkaufsliste vorhanden',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Die Einkaufsliste wird automatisch aus den gewählten Rezepten erstellt.',
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

  Widget _buildShoppingList(BuildContext context, ShoppingList shoppingList) {
    final itemsByCategory = ref.watch(shoppingListByCategoryProvider(widget.tripId));
    
    // Filter items based on current filters
    final filteredItemsByCategory = <String, List<ShoppingItem>>{};
    
    for (final entry in itemsByCategory.entries) {
      final category = entry.key;
      final items = entry.value.where((item) {
        // Filter by category
        if (_selectedCategory != null && category != _selectedCategory) {
          return false;
        }
        
        // Filter by assignee
        if (_selectedAssignee != null && item.assignedTo != _selectedAssignee) {
          return false;
        }
        
        // Filter by completion status
        if (!_showCompleted && item.isCompleted) {
          return false;
        }
        
        return true;
      }).toList();
      
      if (items.isNotEmpty) {
        filteredItemsByCategory[category] = items;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: filteredItemsByCategory.entries.map((entry) {
          final category = entry.key;
          final items = entry.value;
          
          return _buildCategorySection(context, category, items);
        }).toList(),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String category, List<ShoppingItem> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${items.length} Artikel',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ...items.map((item) => _buildShoppingItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildShoppingItem(BuildContext context, ShoppingItem item) {
    final trip = ref.watch(tripDetailsProvider(widget.tripId));
    final members = trip?.members.map((m) => m.name).toList() ?? [];
    final currentUserId = ref.watch(currentUserIdProvider);
    
    // Find current user's name
    final currentUser = trip?.members.firstWhere(
      (m) => m.memberId == currentUserId,
      orElse: () => trip!.members.first,
    ).name;

    return ListTile(
      leading: Checkbox(
        value: item.isCompleted,
        onChanged: (value) {
          // Only allow completion if assigned to current user or not assigned
          if (item.assignedTo == null || item.assignedTo == currentUser) {
            ref.read(shoppingListControllerProvider.notifier).toggleItemCompletion(
              widget.tripId,
              item.id,
              currentUser,
            );
          }
        },
      ),
      title: Text(
        item.name,
        style: TextStyle(
          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          color: item.isCompleted 
              ? Theme.of(context).colorScheme.onSurfaceVariant 
              : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.quantity} ${item.unit}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (item.assignedTo != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  item.assignedTo!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      trailing: _buildAssignButton(context, item, members),
    );
  }

  Widget _buildAssignButton(BuildContext context, ShoppingItem item, List<String> members) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final trip = ref.watch(tripDetailsProvider(widget.tripId));
    
    // Find current user's name
    final currentUser = trip?.members.firstWhere(
      (m) => m.memberId == currentUserId,
      orElse: () => trip!.members.first,
    ).name;
    
    if (item.assignedTo == currentUser) {
      // Show unassign button
      return IconButton(
        icon: const Icon(Icons.person_remove),
        onPressed: () {
          ref.read(shoppingListControllerProvider.notifier).assignItem(
            widget.tripId,
            item.id,
            null,
          );
        },
        tooltip: 'Zuweisung entfernen',
      );
    } else if (item.assignedTo == null) {
      // Show assign button
      return IconButton(
        icon: const Icon(Icons.person_add),
        onPressed: () {
          ref.read(shoppingListControllerProvider.notifier).assignItem(
            widget.tripId,
            item.id,
            currentUser,
          );
        },
        tooltip: 'Sich zuweisen',
      );
    } else {
      // Show who it's assigned to
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          item.assignedTo!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'gemüse':
      case 'vegetables':
        return Icons.eco;
      case 'obst':
      case 'fruits':
        return Icons.apple;
      case 'fleisch':
      case 'meat':
        return Icons.restaurant;
      case 'milchprodukte':
      case 'dairy':
        return Icons.local_drink;
      case 'getreide':
      case 'grains':
        return Icons.grain;
      case 'gewürze':
      case 'spices':
        return Icons.spa;
      default:
        return Icons.shopping_basket;
    }
  }

  void _showAddItemPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddItemPage(tripId: widget.tripId),
      ),
    );
  }

}
