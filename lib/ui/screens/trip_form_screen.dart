import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/trip.dart';
import '../../state/app_state.dart';
import '../../util/dates.dart';
import '../widgets/currency_field.dart';

final _fmt = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR');

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
  late String _currency = widget.trip?.currency ?? 'USD';
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
      helpText: '여행 기간',
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
      currency: _currency,
      startDate: _range.start,
      endDate: _range.end,
    );
    if (mounted) Navigator.of(context).pop(trip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.trip == null ? '새 여행' : '여행 수정')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              autofocus: widget.trip == null,
              decoration: const InputDecoration(
                labelText: '여행 제목',
                hintText: '예: 2026 도쿄 가족여행',
              ),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '여행 제목을 입력해 주세요' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _country,
              decoration: const InputDecoration(
                labelText: '나라/도시 (선택)',
                hintText: '예: 일본 도쿄',
              ),
            ),
            const SizedBox(height: 12),
            CurrencyField(
              label: '현지 통화',
              value: _currency,
              onChanged: (v) => setState(() => _currency = v),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.date_range),
              title: const Text('여행 기간'),
              subtitle: Text(
                '${_fmt.format(_range.start)}\n~ ${_fmt.format(_range.end)}',
              ),
              onTap: _pickRange,
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
