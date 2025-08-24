import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app_state/providers.dart';
import '../../models/trip.dart';
import '../stage1/stage1_view.dart';
import '../stage2/stage2_recipes_view.dart';
import 'widgets/shopping_list_view.dart';
import 'widgets/luggage_list_view.dart';

class TripDetailPage extends ConsumerStatefulWidget {
  final String tripId;

  const TripDetailPage({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends ConsumerState<TripDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize with 2 tabs, will be updated in build
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentStage = ref.read(tripStageProvider(widget.tripId));
    final tabCount = currentStage == TripStage.stage2 ? 4 : 2;
    
    if (_tabController.length != tabCount) {
      _tabController.dispose();
      _tabController = TabController(length: tabCount, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripDetailsProvider(widget.tripId));
    final currentStage = ref.watch(tripStageProvider(widget.tripId));
    final isAdmin = ref.watch(isAdminProvider);

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Trip nicht gefunden'),
        ),
        body: const Center(
          child: Text('Der Trip konnte nicht geladen werden.'),
        ),
      );
    }

    final tabCount = currentStage == TripStage.stage2 ? 4 : 2;
    final tabs = currentStage == TripStage.stage2 
        ? const [
            Tab(text: 'Übersicht'),
            Tab(text: 'Rezepte'),
            Tab(text: 'Gebraucht'),
            Tab(text: 'Gepäck'),
          ]
        : const [
            Tab(text: 'Übersicht'),
            Tab(text: 'Rezepte'),
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: currentStage == TripStage.stage2
            ? [
                _buildOverviewTab(context, trip, currentStage, isAdmin),
                _buildRecipesTab(context, trip),
                _buildShoppingListTab(context, trip),
                _buildLuggageTab(context, trip),
              ]
            : [
                _buildOverviewTab(context, trip, currentStage, isAdmin),
                _buildStageTab(context, currentStage),
              ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Trip trip, TripStage? currentStage) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final startDate = dateFormat.format(trip.startDate);
    final endDate = dateFormat.format(trip.endDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: trip.imagePath != null
                ? Image.asset(
                    trip.imagePath!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.destination,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$startDate - $endDate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              //_buildStageChip(context, currentStage),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageChip(BuildContext context, TripStage? stage) {
    if (stage == null) return const SizedBox.shrink();
    
    final stageText = stage == TripStage.stage1 ? 'Phase 1' : 'Phase 2';
    final color = stage == TripStage.stage1 
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
    
    return Chip(
      label: Text(
        stageText,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
    );
  }

  Widget _buildMembersList(BuildContext context, List<dynamic> members) {
    return ExpansionTile(
      title: Text(
        'Teilnehmer (${members.length})',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: const Border(),
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return _buildMemberTile(context, member);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMemberTile(BuildContext context, dynamic member) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            _getInitials(member.name),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          member.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  member.diet,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (member.allergies.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Allergien: ${member.allergies.join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  Widget _buildOverviewTab(BuildContext context, Trip trip, TripStage? currentStage, bool isAdmin) {
    final daysUntilTrip = trip.startDate.difference(DateTime.now()).inDays;
    final tripDuration = trip.endDate.difference(trip.startDate).inDays + 1;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, trip, currentStage),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSection(context, trip, daysUntilTrip, tripDuration, currentStage),
                const SizedBox(height: 24),
                _buildMembersList(context, trip.members),
                const SizedBox(height: 24),
                if (isAdmin && currentStage == TripStage.stage1) ...[
                  _buildAdminSection(context),
                ],
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Trip trip, int daysUntilTrip, int tripDuration, TripStage? currentStage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                context,
                'Tage bis zum Trip',
                daysUntilTrip >= 0 ? '$daysUntilTrip Tage' : 'Läuft bereits',
                Icons.event,
                daysUntilTrip < 0 ? Colors.orange : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatItem(
                context,
                'Trip-Dauer',
                '$tripDuration Tage',
                Icons.calendar_today,
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
                  Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Geplante Mahlzeiten',
                  '${trip.plannedMeals.length} Rezepte',
                  Icons.restaurant_menu,
                  Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Phase',
                  currentStage == TripStage.stage1 ? 'Phase 1' : 'Phase 2',
                  Icons.flag,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      height: 100, // Feste Höhe für alle Cards
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Admin-Aktionen',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _endStage1(context),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Phase 1 abschließen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStageTab(BuildContext context, TripStage? currentStage) {
    if (currentStage == null) {
      return const Center(
        child: Text('Phasen-Information nicht verfügbar'),
      );
    }

    if (currentStage == TripStage.stage1) {
      return Stage1View(tripId: widget.tripId);
    }

    return const Center(
      child: Text('Stage 2 View wird nicht mehr verwendet'),
    );
  }

  Widget _buildRecipesTab(BuildContext context, Trip trip) {
    return Stage2RecipesView(tripId: widget.tripId);
  }

  Widget _buildShoppingListTab(BuildContext context, Trip trip) {
    return ShoppingListView(tripId: widget.tripId);
  }

  Widget _buildLuggageTab(BuildContext context, Trip trip) {
    return LuggageListView(tripId: widget.tripId);
  }

  void _endStage1(BuildContext context) {
    ref.read(tripStageControllerProvider.notifier).endStage1(widget.tripId);
    
    // Switch to Stage tab
    _tabController.animateTo(1);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Phase 1 erfolgreich abgeschlossen! Phase 2 wurde gestartet.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}




