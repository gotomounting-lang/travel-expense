import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/trip.dart';
import '../../state/app_state.dart';
import '../../util/dates.dart';
import '../widgets/currency_field.dart';

/// 새 여행 만들기 / 여행 정보 수정.
class TripFormScreen extends StatefulWidget {
  const TripFormScreen({super.key, this.trip});

  final Trip? trip;

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.trip?.title);
  late final _country = TextEditingController(text: widget.trip?.country);
  // 새 여행은 통화를 미리 정하지 않는다. (예전 기본값 USD 가 유럽 여행 등에
  // 그대로 저장되는 일이 있었다.) 고르기 전엔 저장할 수 없다.
  late String? _currency = widget.trip?.currency;
  late DateTimeRange _range = widget.trip == null
      ? DateTimeRange(
          start: dateOnly(DateTime.now()),
          end: dateOnly(DateTime.now()).add(const Duration(days: 4)),
        )
      : DateTimeRange(start: widget.trip!.startDate, end: widget.trip!.endDate);
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _country.dispose();
    super.dispose();
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime(DateTime.now().year + 3),
      initialDateRange: _range,
      helpText: AppLocalizations.of(context).tripPeriod,
      // 직접 타자 입력은 키보드에 '.' 이 없는 기기가 있어 막는다 (달력에서만 고른다).
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) setState(() => _range = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final trip = await context.read<AppState>().saveTrip(
      id: widget.trip?.id,
      title: _title.text,
      country: _country.text,
      currency: _currency!,
      startDate: _range.start,
      endDate: _range.end,
    );
    if (mounted) Navigator.of(context).pop(trip);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fmt = DateFormat.yMMMEd(l.localeName);
    return Scaffold(
      appBar: AppBar(title: Text(widget.trip == null ? l.newTrip : l.editTrip)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              autofocus: widget.trip == null,
              decoration: InputDecoration(
                labelText: l.tripTitle,
                hintText: l.tripTitleHint,
              ),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.tripTitleRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _country,
              decoration: InputDecoration(
                labelText: l.countryOptional,
                hintText: l.countryHint,
              ),
            ),
            const SizedBox(height: 12),
            CurrencyField(
              label: l.localCurrency,
              value: _currency,
              onChanged: (v) => setState(() => _currency = v),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.date_range),
              title: Text(l.tripPeriod),
              subtitle: Text(
                '${fmt.format(_range.start)}\n~ ${fmt.format(_range.end)}',
              ),
              onTap: _pickRange,
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
