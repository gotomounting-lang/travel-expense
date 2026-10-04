import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../services/google_account_service.dart';
import '../../services/sheets_sync_service.dart';
import '../../state/app_state.dart';
import '../../state/locale_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final account = context.watch<GoogleAccountService>();
    final theme = Theme.of(context);
    final user = account.account;
    final l = AppLocalizations.of(context);
    final locale = context.watch<LocaleController>();

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.language, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String?>(
            initialValue: locale.choice,
            isExpanded: true,
            items: [
              DropdownMenuItem(value: null, child: Text(l.languageSystem)),
              for (final code in LocaleController.supported)
                DropdownMenuItem(
                  value: code,
                  child: Text(LocaleController.nativeNames[code]!),
                ),
            ],
            onChanged: locale.choose,
          ),
          const Divider(height: 40),
          Text(l.googleSheetsSection, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            l.googleSheetsBody(l.sheetFileTitle),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (user == null)
            FilledButton.icon(
              onPressed: () => account.signIn(),
              icon: const Icon(Icons.login),
              label: Text(l.connectGoogle),
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
            if (_syncText(l, state) case final text?)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  text,
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
                  label: Text(l.syncNow),
                ),
                if (state.sheetUrl != null)
                  OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(state.sheetUrl!),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.open_in_new),
                    label: Text(l.openSheet),
                  ),
                TextButton(
                  onPressed: () => account.signOut(),
                  child: Text(l.disconnect),
                ),
              ],
            ),
          ],
          if (account.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                l.googleSignInError(account.error!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          if (state.cardNotifications.isSupported) ...[
            const Divider(height: 40),
            const _CardAlertsSection(),
          ],
          const Divider(height: 40),
          Text(l.rateInfoTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l.rateInfoBody, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// 카드 결제 알림 자동 기록 켜기. 시스템 설정으로 보내기 전에 무엇을 읽는지
/// 먼저 알리고 동의를 받는다 (Google Play 정책의 사전 고지).
class _CardAlertsSection extends StatefulWidget {
  const _CardAlertsSection();

  @override
  State<_CardAlertsSection> createState() => _CardAlertsSectionState();
}

class _CardAlertsSectionState extends State<_CardAlertsSection> {
  bool? _enabled;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _refresh();
    // 시스템 설정에서 돌아오면 상태를 다시 확인한다.
    _lifecycle = AppLifecycleListener(onResume: _refresh);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final enabled = await context
        .read<AppState>()
        .cardNotifications
        .isEnabled();
    if (mounted) setState(() => _enabled = enabled);
  }

  Future<void> _openSettings() async {
    final l = AppLocalizations.of(context);
    final source = context.read<AppState>().cardNotifications;
    if (_enabled != true) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.cardAlertsConsentTitle),
          content: Text(l.cardAlertsConsentBody(l.appTitle)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.agreeAndContinue),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    await source.openSettings();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final enabled = _enabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.cardAlertsSection, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(l.cardAlertsBody, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        if (enabled != null)
          Row(
            children: [
              Icon(
                enabled ? Icons.check_circle : Icons.notifications_off_outlined,
                color: enabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(enabled ? l.cardAlertsOn : l.cardAlertsOff)),
            ],
          ),
        const SizedBox(height: 8),
        enabled == true
            ? OutlinedButton(
                onPressed: _openSettings,
                child: Text(l.cardAlertsSettings),
              )
            : FilledButton.icon(
                onPressed: _openSettings,
                icon: const Icon(Icons.notifications_active_outlined),
                label: Text(l.cardAlertsAllow),
              ),
      ],
    );
  }
}

String? _syncText(AppLocalizations l, AppState state) {
  switch (state.syncStatus) {
    case SyncStatus.ok:
      return l.syncSaved;
    case SyncStatus.failed:
      final e = state.syncError;
      final details = e is SheetsSyncException
          ? switch (e.reason) {
              SheetsSyncError.notSignedIn => l.syncErrorNotSignedIn,
              SheetsSyncError.noPermission => l.syncErrorNoPermission,
              SheetsSyncError.expired => l.syncErrorExpired,
            }
          : '$e';
      return l.syncFailed(details);
    case SyncStatus.idle:
    case SyncStatus.syncing:
      return null;
  }
}
