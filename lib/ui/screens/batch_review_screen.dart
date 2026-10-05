import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/category.dart';
import '../../models/expense.dart';
import '../../models/trip.dart';
import '../../services/receipt_parser.dart';
import '../../state/app_state.dart';
import '../../util/money.dart';
import 'expense_form_screen.dart';

enum _Status { ok, outsideTrip, duplicate, needsInput }

class _Item {
  _Item(this.draft, this.status) : selected = status == _Status.ok;

  final ReceiptDraft draft;
  final _Status status;
  bool selected;
}

/// 사진 여러 장이나 카드 이용내역 한 화면에서 모두 읽힌 결제 여러 건을 확인하고
/// 한 번에 저장한다. 여행 기간 밖이거나 이미 저장된 건은 처음엔 고르지 않는다.
class BatchReviewScreen extends StatefulWidget {
  const BatchReviewScreen({
    super.key,
    required this.trip,
    required this.drafts,
  });

  final Trip trip;
  final List<ReceiptDraft> drafts;

  @override
  State<BatchReviewScreen> createState() => _BatchReviewScreenState();
}

class _BatchReviewScreenState extends State<BatchReviewScreen> {
  late final List<_Item> _items = [
    for (final d in widget.drafts) _Item(d, _statusOf(d)),
  ];
  bool _saving = false;

  _Status _statusOf(ReceiptDraft d) {
    if (d.amount == null || d.currency == null) return _Status.needsInput;
    final date = d.date;
    if (date != null) {
      final start = widget.trip.startDate.subtract(const Duration(days: 1));
      final end = widget.trip.endDate.add(const Duration(days: 2));
      if (date.isBefore(start) || !date.isBefore(end)) {
        return _Status.outsideTrip;
      }
    }
    final existing = context.read<AppState>().expensesFor(widget.trip.id);
    final duplicate = existing.any(
      (e) =>
          e.currency == d.currency &&
          e.amount == d.amount &&
          date != null &&
          e.spentAt.difference(date).inMinutes.abs() <= 1,
    );
    return duplicate ? _Status.duplicate : _Status.ok;
  }

  /// 날짜를 못 읽은 건은 여행 첫날 정오로 둔다.
  DateTime _dateOf(ReceiptDraft d) =>
      d.date ?? widget.trip.startDate.add(const Duration(hours: 12));

  Future<void> _edit(_Item item) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            ExpenseFormScreen(trip: widget.trip, receipt: item.draft),
      ),
    );
    if (saved == true && mounted) setState(() => _items.remove(item));
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final state = context.read<AppState>();
    final chosen = _items.where((i) => i.selected).toList();
    setState(() => _saving = true);
    for (final item in chosen) {
      final d = item.draft;
      await state.saveExpense(
        tripId: widget.trip.id,
        spentAt: _dateOf(d),
        category: d.category ?? ExpenseCategory.food,
        currency: d.currency!,
        amount: d.amount!,
        merchant: d.merchant,
        paymentMethod: d.paymentMethod,
        source: ExpenseSource.receipt,
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.batchSaved(chosen.length))));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final count = _items.where((i) => i.selected).length;
    final dateFmt = DateFormat.yMMMd(l.localeName).add_Hm();
    return Scaffold(
      appBar: AppBar(title: Text(l.batchTitle(_items.length))),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(l.batchHint, style: theme.textTheme.bodyMedium),
          ),
          for (final item in _items)
            CheckboxListTile(
              value: item.selected,
              onChanged: item.status == _Status.needsInput
                  ? null
                  : (v) => setState(() => item.selected = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                item.draft.merchant.isEmpty ? '—' : item.draft.merchant,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                [
                  if (item.draft.date != null) dateFmt.format(item.draft.date!),
                  switch (item.status) {
                    _Status.outsideTrip => l.batchOutsideTrip,
                    _Status.duplicate => l.batchDuplicate,
                    _Status.needsInput => l.batchNeedsInput,
                    _Status.ok => null,
                  },
                ].nonNulls.join(' · '),
              ),
              secondary: InkWell(
                onTap: () => _edit(item),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    item.draft.amount == null || item.draft.currency == null
                        ? '?'
                        : formatMoney(
                            l,
                            item.draft.amount!,
                            item.draft.currency!,
                          ),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton.icon(
        onPressed: count == 0 || _saving ? null : _save,
        icon: const Icon(Icons.save),
        label: Text(l.batchSave(count)),
      ),
    );
  }
}
