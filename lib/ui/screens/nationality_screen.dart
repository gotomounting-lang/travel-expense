import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/country.dart';
import '../../models/currency.dart';
import '../../state/user_profile.dart';

/// 국적 선택. 국적이 환산 통화와 앱 언어를 정한다.
/// 처음 실행([onboarding])에는 로그인 다음에 나오고, 설정에서도 바꿀 수 있다.
class NationalityScreen extends StatefulWidget {
  const NationalityScreen({super.key, this.onboarding = false});

  final bool onboarding;

  @override
  State<NationalityScreen> createState() => _NationalityScreenState();
}

class _NationalityScreenState extends State<NationalityScreen> {
  String _query = '';

  Future<void> _choose(Country c) async {
    await context.read<UserProfile>().setCountry(c);
    if (!mounted) return;
    // 처음 실행이면 첫 화면(여행 목록)으로, 설정에서 왔으면 설정으로 돌아간다.
    if (widget.onboarding) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = context.watch<UserProfile>();
    final current = profile.country;
    final device = profile.deviceCountry;
    final q = _query.trim().toLowerCase();
    // 기기(플레이스토어) 지역의 나라를 맨 위에.
    final ordered = [?device, ...Country.all.where((c) => c != device)];
    final countries = ordered.where((c) {
      if (q.isEmpty) return true;
      return [
        c.code,
        c.currency,
        for (final lang in const ['ko', 'en', 'zh', 'ja']) c.name(lang),
      ].any((s) => s.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.chooseNationality),
        automaticallyImplyLeading: !widget.onboarding,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(l.nationalityBody, style: theme.textTheme.bodyMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l.searchCountry,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, i) {
                final c = countries[i];
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 28)),
                  title: Text(c.name(l.localeName)),
                  subtitle: Text(
                    '${c.currency} · ${Currency.byCode(c.currency).name(l.localeName)}',
                  ),
                  trailing: (current ?? device)?.code == c.code
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () => _choose(c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
