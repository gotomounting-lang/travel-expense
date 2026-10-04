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

  final String value;
  final ValueChanged<String> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = [
      ...Currency.common,
      if (!Currency.common.any((c) => c.code == value)) Currency.byCode(value),
    ];
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label ?? l.currency),
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
