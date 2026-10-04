import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/google_account_service.dart';
import '../../state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final account = context.watch<GoogleAccountService>();
    final theme = Theme.of(context);
    final user = account.account;

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('구글 스프레드시트', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            '내 구글 계정으로 로그인하면 내 구글 드라이브에 "여행 경비" 시트가 '
            '만들어지고, 기록할 때마다 자동으로 저장됩니다. 이 앱은 앱이 만든 '
            '시트에만 접근하며, 내역은 운영자 서버로 보내지 않습니다.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (user == null)
            FilledButton.icon(
              onPressed: () => account.signIn(),
              icon: const Icon(Icons.login),
              label: const Text('구글 계정으로 연결'),
            )
          else ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: user.photoUrl == null
                    ? null
                    : NetworkImage(user.photoUrl!),
                child: user.photoUrl == null ? const Icon(Icons.person) : null,
              ),
              title: Text(user.displayName ?? user.email),
              subtitle: Text(user.email),
            ),
            if (state.syncMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  state.syncMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: state.syncStatus == SyncStatus.failed
                        ? theme.colorScheme.error
                        : null,
                  ),
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: state.syncStatus == SyncStatus.syncing
                      ? null
                      : () => state.syncNow(interactive: true),
                  icon: state.syncStatus == SyncStatus.syncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                  label: const Text('지금 저장'),
                ),
                if (state.sheetUrl != null)
                  OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(state.sheetUrl!),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('시트 열기'),
                  ),
                TextButton(
                  onPressed: () => account.signOut(),
                  child: const Text('연결 해제'),
                ),
              ],
            ),
          ],
          if (account.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                account.error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          const Divider(height: 40),
          Text('환율 안내', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            '결제한 날짜의 기준환율(유럽중앙은행 고시, 미지원 통화는 공개 환율 '
            '자료)로 원화를 계산합니다. 주말·공휴일은 직전 영업일 환율을 쓰며, '
            '실제 카드 청구액은 카드사 환율과 수수료 때문에 조금 다를 수 있습니다.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
