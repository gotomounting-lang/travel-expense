import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/currency.dart';

/// 자주 쓰는 통화 드롭다운. 목록에 없는 통화가 넘어와도 항목에 추가해 보여준다.
class CurrencyField extends StatelessWidget {
  const CurrencyField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  /// null 이면 아무것도 고르지 않은 상태로 두고, 고르기 전엔 저장할 수 없다.
  final String? value;
  final ValueChanged<String> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = [
      ...Currency.common,
      if (value != null && !Currency.common.any((c) => c.code == value))
        Currency.byCode(value!),
    ];
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label ?? l.currency),
      validator: (v) => v == null ? l.currencyRequired : null,
      items: [
        for (final c in items)
          DropdownMenuItem(
            value: c.code,
            child: Text('${c.code}  ${c.name(l.localeName)}'),
          ),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
