import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/expense.dart';
import '../../services/sheet_rows.dart';
import '../../state/app_state.dart';
import '../../util/dates.dart';
import '../../util/money.dart';
import '../widgets/category_pie_chart.dart';
import 'expense_form_screen.dart';
import 'trip_form_screen.dart';

final _dayHeader = DateFormat('M월 d일 (E)', 'ko_KR');
final _time = DateFormat('HH:mm');

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('여행을 삭제할까요?'),
        content: const Text('이 여행의 모든 지출 내역이 함께 삭제되고, 다음 동기화 때 시트에서도 빠집니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('삭제'),
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
    final totals = categoryTotals(expenses);
    final total = totals.values.fold<int>(0, (s, v) => s + v);
    final pending = expenses.where((e) => !e.hasRate).length;
    final theme = Theme.of(context);

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
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('여행 수정')),
              PopupMenuItem(value: 'delete', child: Text('여행 삭제')),
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
            Text('총 지출', style: theme.textTheme.labelLarge),
            Text(
              formatKrw(total),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (pending > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '환율 확인 대기 $pending건 (인터넷 연결 후 아래로 당겨 새로고침)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            CategoryPieChart(totals: totals),
            const SizedBox(height: 16),
            if (expenses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('+ 버튼으로 첫 지출을 기록하세요')),
              ),
            for (final day in byDay.keys) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  _dayHeader.format(day),
                  style: theme.textTheme.titleSmall,
                ),
              ),
              for (final e in byDay[day]!) _ExpenseTile(expense: e),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ExpenseFormScreen(trip: trip)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('지출 추가'),
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final e = expense;
    final theme = Theme.of(context);
    final trip = context.read<AppState>().tripById(e.tripId)!;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: e.category.color.withValues(alpha: 0.15),
        foregroundColor: e.category.color,
        child: Icon(e.category.icon, size: 20),
      ),
      title: Text(e.merchant.isEmpty ? e.category.label : e.merchant),
      subtitle: Text(
        '${_time.format(e.spentAt)} · '
        '${formatForeign(e.amount, e.currency)}',
      ),
      trailing: Text(
        e.krwAmount == null ? '환율 대기' : formatKrw(e.krwAmount!),
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: e.krwAmount == null ? theme.colorScheme.error : null,
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
