import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/expense.dart';
import '../../models/trip.dart';
import '../../services/card_notification_parser.dart';
import '../../services/receipt_scanner.dart';
import '../../services/sheet_rows.dart';
import '../../state/app_state.dart';
import '../../util/dates.dart';
import '../../util/money.dart';
import '../widgets/category_pie_chart.dart';
import 'expense_form_screen.dart';
import 'trip_form_screen.dart';

final _time = DateFormat('HH:mm');

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  Future<void> _confirmDelete(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteTripConfirmTitle),
        content: Text(l.deleteTripConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.of(context).pop();
      await context.read<AppState>().deleteTrip(tripId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final trip = state.tripById(tripId);
    if (trip == null) return const Scaffold();

    final expenses = state.expensesFor(tripId);
    final home = state.homeCurrency();
    final totals = categoryTotals(expenses, home);
    final total = totals.values.fold<double>(0, (s, v) => s + v);
    final pending = expenses.length - state.convertedFor(tripId).length;
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dayHeader = DateFormat.MMMEd(l.localeName);

    // 날짜별로 묶어서 보여준다 (최신 날짜 먼저).
    final byDay = <DateTime, List<Expense>>{};
    for (final e in expenses) {
      byDay.putIfAbsent(dateOnly(e.spentAt), () => []).add(e);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TripFormScreen(trip: trip)),
                );
              } else if (v == 'delete') {
                _confirmDelete(context);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: Text(l.editTrip)),
              PopupMenuItem(value: 'delete', child: Text(l.deleteTrip)),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await state.refreshMissingRates();
          await state.syncNow();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            Text(l.totalSpent, style: theme.textTheme.labelLarge),
            Text(
              formatMoney(l, total, home),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (pending > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l.pendingRates(pending),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            CategoryPieChart(totals: totals, currency: home),
            const SizedBox(height: 16),
            if (expenses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text(l.firstExpenseHint)),
              ),
            for (final day in byDay.keys) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  dayHeader.format(day),
                  style: theme.textTheme.titleSmall,
                ),
              ),
              for (final e in byDay[day]!) _ExpenseTile(expense: e),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addExpense(context, trip),
        icon: const Icon(Icons.add),
        label: Text(l.addExpense),
      ),
    );
  }
}

enum _AddMode { camera, gallery, paste, manual }

/// 지출 추가 방법 고르기: 영수증 촬영 / 앨범 사진 / 직접 입력.
Future<void> _addExpense(BuildContext context, Trip trip) async {
  final l = AppLocalizations.of(context);
  final mode = await showModalBottomSheet<_AddMode>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l.scanReceipt),
            onTap: () => Navigator.pop(ctx, _AddMode.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l.pickReceipt),
            onTap: () => Navigator.pop(ctx, _AddMode.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.content_paste),
            title: Text(l.pasteCardAlert),
            onTap: () => Navigator.pop(ctx, _AddMode.paste),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l.enterManually),
            onTap: () => Navigator.pop(ctx, _AddMode.manual),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Text(
              l.photoDeletedNote,
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    ),
  );
  if (mode == null || !context.mounted) return;

  final navigator = Navigator.of(context);
  if (mode == _AddMode.manual) {
    navigator.push(
      MaterialPageRoute(builder: (_) => ExpenseFormScreen(trip: trip)),
    );
    return;
  }
  if (mode == _AddMode.paste) {
    await _pasteCardAlert(context, trip);
    return;
  }

  final scanner = context.read<ReceiptScanner>();
  final messenger = ScaffoldMessenger.of(context);
  final source = mode == _AddMode.camera
      ? ReceiptImageSource.camera
      : ReceiptImageSource.gallery;
  var progressShown = false;
  try {
    final draft = await scanner.scan(
      trip,
      source,
      // 사진을 고른 뒤 분석하는 동안만 진행 표시를 띄운다.
      onAnalyzing: () {
        progressShown = true;
        showDialog<void>(
          context: navigator.context,
          barrierDismissible: false,
          builder: (_) => PopScope(
            canPop: false,
            child: AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20),
                  Expanded(child: Text(l.readingReceipt)),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (progressShown) navigator.pop();
    if (draft == null) return; // 사진을 고르지 않음
    navigator.push(
      MaterialPageRoute(
        builder: (_) => ExpenseFormScreen(trip: trip, receipt: draft),
      ),
    );
  } catch (e) {
    if (progressShown) navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l.receiptScanFailed('$e'))));
  }
}

/// iOS 처럼 알림을 자동으로 읽을 수 없을 때: 알림 문구를 붙여넣어 읽는다.
Future<void> _pasteCardAlert(BuildContext context, Trip trip) async {
  final l = AppLocalizations.of(context);
  final controller = TextEditingController();
  final text = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.pasteCardAlert),
      content: TextField(
        controller: controller,
        autofocus: true,
        minLines: 3,
        maxLines: 8,
        decoration: InputDecoration(hintText: l.pasteCardAlertHint),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          child: Text(l.read),
        ),
      ],
    ),
  );
  controller.dispose();
  if (text == null || text.trim().isEmpty || !context.mounted) return;

  final payment =
      CardNotificationParser(
        homeCurrency: context.read<AppState>().homeCurrency(),
      ).parse(
        CardNotification(id: 'paste', text: text, postedAt: DateTime.now()),
        useTextDate: true,
      );
  if (payment == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.pasteCardAlertFailed)));
  }
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => payment == null
          ? ExpenseFormScreen(trip: trip)
          : ExpenseFormScreen(
              trip: trip,
              receipt: payment.toDraft(),
              draftSource: ExpenseSource.cardNotification,
            ),
    ),
  );
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final e = expense;
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final trip = state.tripById(e.tripId)!;
    final converted = e.hasRate && e.homeCurrency == state.homeCurrency();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: e.category.color.withValues(alpha: 0.15),
        foregroundColor: e.category.color,
        child: Icon(e.category.icon, size: 20),
      ),
      title: Text(e.merchant.isEmpty ? e.category.label(l) : e.merchant),
      subtitle: Text(
        '${_time.format(e.spentAt)} · '
        '${formatForeign(e.amount, e.currency)}',
      ),
      trailing: Text(
        converted
            ? formatMoney(l, e.homeAmount!, e.homeCurrency)
            : l.ratePending,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: converted ? null : theme.colorScheme.error,
        ),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ExpenseFormScreen(trip: trip, expense: e),
        ),
      ),
    );
  }
}
