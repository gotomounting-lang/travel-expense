import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/expense_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../models/currency.dart';
import '../../models/category.dart';
import '../../models/expense.dart';
import '../../models/trip.dart';
import '../../services/receipt_parser.dart';
import '../../state/app_state.dart';
import '../../util/dates.dart';
import '../../util/money.dart';
import '../widgets/currency_field.dart';

final _rateFmt = NumberFormat('#,##0.####');

/// 지출 추가 / 수정. 결제한 날짜의 환율로 원화 금액을 미리 보여준다.
/// [receipt] 가 있으면 영수증에서 읽은 내용으로 채워 확인받는다.
class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({
    super.key,
    required this.trip,
    this.expense,
    this.receipt,
    this.draftSource = ExpenseSource.receipt,
  });

  final Trip trip;
  final Expense? expense;

  /// 영수증이나 붙여넣은 카드 알림에서 읽은 내용.
  final ReceiptDraft? receipt;

  /// [receipt] 가 어디서 왔는지 (영수증 / 카드 알림).
  final ExpenseSource draftSource;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ReceiptDraft? _receipt = widget.receipt;
  late final _amount = TextEditingController(
    text: switch ((widget.expense?.amount, _receipt?.amount)) {
      (final double v, _) => _plain(v),
      (_, final double v) => _plain(v),
      _ => '',
    },
  );
  late final _merchant = TextEditingController(
    text: widget.expense?.merchant ?? _receipt?.merchant,
  );
  late final _payment = TextEditingController(
    text: widget.expense?.paymentMethod ?? _receipt?.paymentMethod,
  );
  late final _memo = TextEditingController(
    text:
        widget.expense?.memo ??
        _receipt?.items.map((i) => '${i.name} ${_plain(i.price)}').join('\n'),
  );

  /// 영수증에서 통화를 확인하지 못했으면 null 로 두고 사용자가 고르게 한다.
  late String? _currency =
      widget.expense?.currency ??
      (_receipt != null
          ? _receipt.currency ?? _receipt.suggestedCurrency
          : widget.trip.currency);
  late ExpenseCategory _category =
      widget.expense?.category ?? _receipt?.category ?? ExpenseCategory.food;
  late DateTime _spentAt =
      widget.expense?.spentAt ?? _receiptDate() ?? _defaultSpentAt();
  Future<CachedRate>? _rate;
  bool _saving = false;

  static String _plain(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  /// 영수증 날짜. 시간이 없으면 지금 시각(여행 중이면) 대신 정오로 둔다.
  DateTime? _receiptDate() {
    final d = _receipt?.date;
    if (d == null) return null;
    final hasTime = d.hour != 0 || d.minute != 0;
    return hasTime ? d : d.add(const Duration(hours: 12));
  }

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
    final state = context.read<AppState>();
    final currency = _currency;
    _rate = currency == null
        ? null
        : state.rates.rate(currency, state.homeCurrency(), _spentAt);
  }

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    _payment.dispose();
    _memo.dispose();
    super.dispose();
  }

  double? get _amountValue => ReceiptParser.parseAmount(
    _amount.text.trim(),
    decimals: Currency.byCode(_currency ?? widget.trip.currency).decimals,
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _spentAt,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
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
      currency: _currency!,
      amount: _amountValue!,
      merchant: _merchant.text,
      paymentMethod: _payment.text,
      memo: _memo.text,
      source: _receipt == null ? ExpenseSource.manual : widget.draftSource,
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final state = context.read<AppState>();
    Navigator.of(context).pop();
    await state.deleteExpense(widget.expense!.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? l.addExpense : l.editExpense),
        actions: [
          if (widget.expense != null)
            IconButton(
              tooltip: l.delete,
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
            if (_receipt != null)
              Card(
                // 금액·통화를 확인하지 못했으면 눈에 띄게 경고 색으로.
                color:
                    widget.draftSource != ExpenseSource.cardNotification &&
                        (_receipt.amount == null || _receipt.currency == null)
                    ? theme.colorScheme.errorContainer
                    : theme.colorScheme.secondaryContainer,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.draftSource == ExpenseSource.cardNotification
                              ? l.cardReadNotice
                              : _receipt.amount == null
                              ? l.receiptTotalNotFound
                              : _receipt.currency == null &&
                                    _receipt.suggestedCurrency != null
                              ? l.receiptCurrencySuggested
                              : _receipt.currency == null
                              ? l.receiptCurrencyNotFound
                              : l.receiptReadNotice,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _amount,
                    autofocus: widget.expense == null,
                    style: theme.textTheme.headlineSmall,
                    decoration: InputDecoration(labelText: l.amount),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    validator: (_) {
                      final v = _amountValue;
                      if (v == null || v <= 0) return l.amountRequired;
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
            if (_currency case final currency?)
              _HomePreview(
                rate: _rate,
                amount: _amountValue,
                currency: currency,
                home: context.read<AppState>().homeCurrency(),
              ),
            const SizedBox(height: 16),
            Text(l.category, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in ExpenseCategory.values)
                  ChoiceChip(
                    avatar: Icon(c.icon, size: 18, color: c.color),
                    label: Text(c.label(l)),
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
                    label: Text(
                      DateFormat.yMMMEd(l.localeName).format(_spentAt),
                    ),
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
              decoration: InputDecoration(
                labelText: l.merchantOptional,
                hintText: l.merchantHint,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _payment,
              decoration: InputDecoration(
                labelText: l.paymentOptional,
                hintText: l.paymentHint,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _memo,
              decoration: InputDecoration(labelText: l.memoOptional),
              minLines: 1,
              maxLines: 6,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomePreview extends StatelessWidget {
  const _HomePreview({
    required this.home,
    required this.rate,
    required this.amount,
    required this.currency,
  });

  final Future<CachedRate>? rate;
  final double? amount;
  final String currency;
  final String home;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return FutureBuilder<CachedRate>(
      future: rate,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Text(l.checkingRate, style: style);
        }
        if (snap.hasError || !snap.hasData) {
          return Text(l.rateUnavailable, style: style);
        }
        final r = snap.data!;
        final converted = amount == null
            ? null
            : Expense.roundTo(amount! * r.rate, Currency.byCode(home).decimals);
        return Text(
          '${converted == null ? '' : '${l.approxAmount(formatMoney(l, converted, home))}  ·  '}'
          '${l.rateInfo(currency, _rateFmt.format(r.rate), home, formatYmd(r.rateDate))}',
          style: style,
        );
      },
    );
  }
}
