import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/trip.dart';
import '../../state/app_state.dart';
import '../../util/money.dart';
import 'settings_screen.dart';
import 'trip_detail_screen.dart';
import 'trip_form_screen.dart';

class TripListScreen extends StatelessWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = AppLocalizations.of(context);
    final trips = state.trips;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(
            tooltip: l.settings,
            icon: Icon(
              state.account.isSignedIn
                  ? Icons.cloud_done_outlined
                  : Icons.settings_outlined,
            ),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.waitingCardPayments > 0)
            MaterialBanner(
              leading: const Icon(Icons.credit_card),
              content: Text(l.cardAlertsWaiting(state.waitingCardPayments)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TripFormScreen()),
                  ),
                  child: Text(l.newTrip),
                ),
              ],
            ),
          Expanded(
            child: trips.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: trips.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) => _TripCard(trip: trips[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final trip = await Navigator.of(context).push<Trip>(
            MaterialPageRoute(builder: (_) => const TripFormScreen()),
          );
          if (trip != null && context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TripDetailScreen(tripId: trip.id),
              ),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l.newTrip),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final expenses = state.expensesFor(trip.id);
    final total = expenses.fold<int>(0, (s, e) => s + (e.krwAmount ?? 0));
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final range = DateFormat.yMd(l.localeName);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(trip.title, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${trip.country.isEmpty ? '' : '${trip.country} · '}'
          '${range.format(trip.startDate)} ~ ${range.format(trip.endDate)}'
          ' · ${l.expenseCount(expenses.length)}',
        ),
        trailing: Text(
          formatKrw(l, total),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: trip.id)),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flight_takeoff,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(l.emptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              l.emptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
