import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/expense_repository.dart';
import '../../models/category.dart';
import '../../models/expense.dart';
import '../../models/trip.dart';
import '../../state/app_state.dart';
import '../../util/dates.dart';
import '../../util/money.dart';
import '../widgets/currency_field.dart';

final _dateFmt = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR');
final _rateFmt = NumberFormat('#,##0.####');

/// 지출 추가 / 수정. 결제한 날짜의 환율로 원화 금액을 미리 보여준다.
class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key, required this.trip, this.expense});

  final Trip trip;
  final Expense? expense;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: widget.expense == null ? '' : _plain(widget.expense!.amount),
  );
  late final _merchant = TextEditingController(text: widget.expense?.merchant);
  late final _payment = TextEditingController(
    text: widget.expense?.paymentMethod,
  );
  late final _memo = TextEditingController(text: widget.expense?.memo);
  late String _currency = widget.expense?.currency ?? widget.trip.currency;
  late ExpenseCategory _category =
      widget.expense?.category ?? ExpenseCategory.food;
  late DateTime _spentAt = widget.expense?.spentAt ?? _defaultSpentAt();
  Future<CachedRate>? _rate;
  bool _saving = false;

  static String _plain(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  /// 여행 기간 중이면 지금, 아니면 여행 첫날 정오.
  DateTime _defaultSpentAt() {
    final now = DateTime.now();
    final today = dateOnly(now);
    if (!today.isBefore(widget.trip.startDate) &&
        !today.isAfter(widget.trip.endDate)) {
      return now;
    }
    return widget.trip.startDate.add(const Duration(hours: 12));
  }

  @override
  void initState() {
    super.initState();
    _loadRate();
    _amount.addListener(() => setState(() {}));
  }

  void _loadRate() {
    _rate = context.read<AppState>().rates.krwRate(_currency, _spentAt);
  }

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    _payment.dispose();
    _memo.dispose();
    super.dispose();
  }

  double? get _amountValue =>
      double.tryParse(_amount.text.replaceAll(',', '').trim());

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _spentAt,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      _spentAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _spentAt.hour,
        _spentAt.minute,
      );
      _loadRate();
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_spentAt),
    );
    if (picked == null) return;
    setState(() {
      _spentAt = DateTime(
        _spentAt.year,
        _spentAt.month,
        _spentAt.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await context.read<AppState>().saveExpense(
      id: widget.expense?.id,
      tripId: widget.trip.id,
      spentAt: _spentAt,
      category: _category,
      currency: _currency,
      amount: _amountValue!,
      merchant: _merchant.text,
      paymentMethod: _payment.text,
      memo: _memo.text,
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final state = context.read<AppState>();
    Navigator.of(context).pop();
    await state.deleteExpense(widget.expense!.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? '지출 추가' : '지출 수정'),
        actions: [
          if (widget.expense != null)
            IconButton(
              tooltip: '삭제',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _amount,
                    autofocus: widget.expense == null,
                    style: theme.textTheme.headlineSmall,
                    decoration: const InputDecoration(labelText: '금액'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    validator: (_) {
                      final v = _amountValue;
                      if (v == null || v <= 0) return '금액을 입력해 주세요';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: CurrencyField(
                    value: _currency,
                    onChanged: (v) => setState(() {
                      _currency = v;
                      _loadRate();
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _KrwPreview(rate: _rate, amount: _amountValue, currency: _currency),
            const SizedBox(height: 16),
            Text('카테고리', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in ExpenseCategory.values)
                  ChoiceChip(
                    avatar: Icon(c.icon, size: 18, color: c.color),
                    label: Text(c.label),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event),
                    label: Text(_dateFmt.format(_spentAt)),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.schedule),
                  label: Text(DateFormat('HH:mm').format(_spentAt)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _merchant,
              decoration: const InputDecoration(
                labelText: '가맹점 (선택)',
                hintText: '예: 이치란 라멘',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _payment,
              decoration: const InputDecoration(
                labelText: '결제수단 (선택)',
                hintText: '예: 신한카드, 현금',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _memo,
              decoration: const InputDecoration(labelText: '메모 (선택)'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}

class _KrwPreview extends StatelessWidget {
  const _KrwPreview({
    required this.rate,
    required this.amount,
    required this.currency,
  });

  final Future<CachedRate>? rate;
  final double? amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return FutureBuilder<CachedRate>(
      future: rate,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Text('환율 확인 중…', style: style);
        }
        if (snap.hasError || !snap.hasData) {
          return Text(
            '지금은 환율을 가져올 수 없어요. 저장해 두면 연결될 때 원화로 바꿔 드립니다.',
            style: style,
          );
        }
        final r = snap.data!;
        final krw = amount == null ? null : (amount! * r.rate).round();
        return Text(
          '${krw == null ? '' : '≈ ${formatKrw(krw)}  ·  '}'
          '1 $currency = ${_rateFmt.format(r.rate)}원 '
          '(${formatYmd(r.rateDate)} 기준)',
          style: style,
        );
      },
    );
  }
}
