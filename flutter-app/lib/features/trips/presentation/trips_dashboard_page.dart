import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app_state/providers.dart';
import '../presentation/widgets/trip_card.dart';
import '../../models/trip.dart';

class TripsDashboardPage extends ConsumerWidget {
  const TripsDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider);

    // Basic split: choose earliest upcoming as "next trip"
    final sorted = [...trips]..sort((a, b) => a.startDate.compareTo(b.startDate));
    final TripSummary? nextTrip = sorted.isNotEmpty ? sorted.first : null;
    final allTrips =
        sorted.isNotEmpty ? sorted.skip(1).toList(growable: false) : const <dynamic>[];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {},
                tooltip: 'Profil',
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
                tooltip: 'Einstellungen',
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: SliverToBoxAdapter(
              child: _JoinByCodeCard(),
            ),
          ),
          if (nextTrip != null) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Nächster Trip',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              sliver: SliverToBoxAdapter(
                child: _TripCardSection(trip: nextTrip),
              ),
            ),
          ],
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Alle Trips',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList.separated(
              itemCount: allTrips.length,
              itemBuilder: (context, index) {
                final trip = allTrips[index] as TripSummary;
                return _TripCardSection(trip: trip);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Mock create: simply show a SnackBar; creation is out of scope for now
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip erstellen (Mock)')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Neuer Trip'),
      ),
    );
  }
}

class _JoinByCodeCard extends StatefulWidget {
  @override
  State<_JoinByCodeCard> createState() => _JoinByCodeCardState();
}

class _JoinByCodeCardState extends State<_JoinByCodeCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip über Code beitreten', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Code hier eingeben',
                      border: border,
                      enabledBorder: border,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('QR scannen (Mock)')),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'QR scannen',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TripCardSection extends ConsumerWidget {
  const _TripCardSection({required this.trip});

  final TripSummary trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = ref.watch(tripStageProvider(trip.id));
    return TripCard(
      title: trip.name,
      destination: trip.destination,
      dateRange: _formatDateRange(context, trip.startDate, trip.endDate),
      stageLine: _stageLine(stage),
      thumbnail: trip.imagePath != null 
          ? Image.asset(
              trip.imagePath!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => 
                  Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported_outlined, size: 36),
                  ),
            )
          : Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image_not_supported_outlined, size: 36),
            ),
      onTap: () => context.go('/trips/${trip.id}'),
    );
  }

  String _formatDateRange(BuildContext context, DateTime a, DateTime b) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    // e.g. "22. Aug. – 24. Aug."
    final fmt = DateFormat('d. MMM.', locale);
    return '${fmt.format(a)} – ${fmt.format(b)}';
  }

  String _stageLine(TripStage? stage) {
    switch (stage) {
      case TripStage.stage1:
        return 'Rezeptplanung';
      case TripStage.stage2:
        return 'Einkäufe und Packen';
      case null:
        return 'Unbekannte Phase';
    }
  }
}
